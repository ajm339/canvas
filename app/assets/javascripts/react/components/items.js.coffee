pathToCurrentUser = ->
  return '/api/v1/user'
pathToItemID = (itemID) ->
  return '/api/v1/user/items/' + itemID
pathToVersionsForItemID = (itemID) ->
  return pathToItemID(itemID) + '/versions'
pathToFollowersForItemID = (itemID) ->
  return pathToItemID(itemID) + '/followers'
pathToWorkspaces = ->
  return '/api/v1/user/workspaces'
pathToWorkspaceID = (workspaceID) ->
  return pathToWorkspaces() + '/' + workspaceID

window.Canvas or= {}
Canvas.CurrentUser = {}

Canvas.DragHandle = React.createClass
  getInitialState: ->
    return { isDragging: false, xOffset: 0 }
  render: ->
    React.DOM.div
      className: 'ItemDragHandle'
      onClick: @props.onClick
      onMouseDown: @props.onMouseDown
Canvas.ItemAddButton = React.createClass
  addItem: ->
    @props.onAddItem(Canvas.ITEM_TYPES[@props.index])
  render: ->
    React.DOM.div
      className: 'ItemAddButton'
      'data-type': Canvas.ITEM_TYPES[@props.index]
      children:
        React.DOM.span
          className: 'Icon'
          children: window['ICON_' + Canvas.ITEM_TYPES[@props.index].toUpperCase()]
          onClick: this.addItem
Canvas.RootItemHeader = React.createClass
  render: ->
    React.DOM.div
      className: 'RootItemHeader'
      children: [
        React.DOM.div
          className: 'RootItemSearch'
          children:
            React.DOM.input
              type: 'text'
              placeholder: 'Search this canvas'
        React.DOM.div
          className: 'RootItemAdd'
          children: [
            React.DOM.p
              className: 'RootItemAddPrompt'
              children: 'Add item:'
            React.DOM.div
              className: 'RootItemAddButtons'
              children: Canvas.ItemAddButton(index: num, onAddItem: @props.onAddItem) for num in [0...Canvas.ITEM_TYPES.length]
          ]
      ]

Canvas.MemberSelect = React.createClass
  getInitialState: ->
    return { filteredMembers: @props.members, allMembers: @props.members, selectedIndex: -1 }
  filterChanged: (event) ->
    searchText = $(event.target).val()
    members = @state.allMembers
    filtered = []
    for m in members
      names = m.display_name.split(' ')
      fname = names[0]
      lname = names[1]
      email = m.email
      if fname.indexOf(searchText) >= 0 || lname.indexOf(searchText) >= 0 || email.indexOf(searchText) >= 0 || m.name.indexOf(searchText) >= 0
        filtered.push(m)
    @setState(filteredMembers: filtered)
  keyDown: (event) ->
    kc = if event.nativeEvent then event.nativeEvent.keyCode else event.keyCode
    event.stopPropagation() if kc == 8 || kc == 46
    index = @state.selectedIndex
    if kc == 40 # Down arrow
      index++ if @state.selectedIndex < (@state.filteredMembers.length - 1)
    else if kc == 38  # Up arrow
      index-- if @state.selectedIndex > 0
    else if kc == 13  # Return
      @props.onAddFollower(@state.filteredMembers[@state.selectedIndex].id) if @state.selectedIndex >= 0
    @setState(selectedIndex: index)
  selectMember: (event) ->
    index = $(event.target).data('index') || $(event.target).parent('.MemberSelectItem').data('index')
    @props.onAddFollower(@state.filteredMembers[index].id)
  render: ->
    _t = this
    index = 0
    membersList = @state.filteredMembers.map((member) ->
      isFollower = false
      _t.props.followers.map((follower) ->
        isFollower = true if follower.id == member.id
      )
      name = member.display_name.split(' ')
      initials = name[0].slice(0,1) + name[1].slice(0,1)
      className = 'MemberSelectItem'
      if index == _t.state.selectedIndex
        className += ' Selected'
      li = (
        React.DOM.li
          className: className
          onClick: _t.selectMember
          'data-index': index
          children: [
            React.DOM.div
              className: 'ProfileImage Small'
              children: initials
            React.DOM.div
              className: 'MemberText'
              children: [
                React.DOM.h2
                  className: 'MemberName'
                  children: member.display_name
                  'data-index': index  # Hack to get data index working?
                React.DOM.p
                  className: 'MemberEmail'
                  children: member.email
                  'data-index': index  # Hack to get data index working?
              ]
          ]
      )
      index++
      return if isFollower
      return li
    )
    React.DOM.div
      className: 'MemberSelect'
      children: [
        React.DOM.input
          className: 'Small'
          type: 'text'
          placeholder: 'Find by name or email'
          onKeyUp: this.filterChanged
          onKeyDown: this.keyDown
        React.DOM.ul
          className: 'MemberSelectList'
          children: membersList
      ]

Canvas.NoteDetails = React.createClass
  render: ->
    React.DOM.div
      className: 'NoteDetails'
      children: [
        React.DOM.p
          children: 'Note created on ' + @props.item.created_at
      ]
Canvas.ItemFollowers = React.createClass
  render: ->
    followers = @props.followers.map((f) ->
      initials = f.fname.slice(0,1) + f.lname.slice(0,1)
      c = 'Small FollowerProfile'
      return (React.DOM.div
        className: c
        children: initials
      )
    )
    followers.push(
      React.DOM.div
        className: 'AddFollower'
        # onClick: this.addFollower
        children: 
          React.DOM.span
            className: 'Icon'
            children: ICON_PLUS
    )
    React.DOM.div
      className: 'ItemFollowers'
      children: [
        React.DOM.h1
          className: 'Inset'
          children: 'Followers'
        React.DOM.div
          className: 'ItemFollowersGroup'
          children: followers
      ]
Canvas.SelectedItemID = -1
Canvas.ItemDetails = React.createClass
  getInitialState: ->
    # Hacking current user in — TODO: don't know why it's not working
    return { followers: [Canvas.CurrentUser], members: @props.members || [], isInitial: true }
  getFollowersForItemID: (itemID) ->
    console.log('getFollowersForItemID')
    $.get pathToFollowersForItemID(itemID), (resp) =>
      if resp.length < 1
        $.get pathToCurrentUser, (resp) =>
          @setState(followers: [resp])
      else
        @setState(followers: resp)
  componentWillMount: ->
    @getFollowersForItemID(Canvas.SelectedItemID) if Canvas.SelectedItemID > 0
  componentWillReceiveProps: (nextProps) ->
    @setState(members: nextProps.members) if nextProps.members
    # @getFollowersForItemID(nextProps.itemID) if @state.isInitial && nextProps.itemID && nextProps.itemID >= 0
    # @setState(isInitial: false)
  click: (event) ->
    event.stopPropagation()
  addFollower: (user_id) ->
    follower = null
    for m in @state.members
      follower = m if m.id == user_id
    return if !follower
    fs = @state.followers
    fs.push(follower)
    @setState(followers: fs)
    url = '/api/v1/user/items/' + Canvas.SelectedItemID + '/followers'
    $.post url,
      follower: { user_id: follower.id },
      success: => return
  render: ->
    children = []
    children.push(Canvas[@props.item.latest_content.type + 'Details'](item: @props.item)) if @props.item
    children.push(Canvas.ItemFollowers(followers: @state.followers))
    children.push(Canvas.MemberSelect(followers: @state.followers, onAddFollower: this.addFollower, members: @state.members))
    children.push(
      React.DOM.div
        className: 'Inset DeleteItem'
        children:
          React.DOM.span
            className: 'Icon'
            onClick: @props.onRemove
            children: ICON_TRASH
    )
    React.DOM.section
      className: 'ItemDetails' + (if @props.item then ' ' + @props.item.latest_content.type + 'Details Active' else '')
      onClick: this.click
      children: children
Canvas.RootItem = React.createClass
  getInitialState: ->
    # TODO: Get root item here, rather than in ItemsContainer
    if !@props.item 
      return { left: 0, top: 0, children: [], selectedIndex: -1, dragIndex: -1, dragDiff: 0, workspaceMembers: [] }
    else
      return { left: 0, top: 0, children: @props.item.children || [], selectedIndex: -1, dragIndex: -1, dragDiff: 0, workspaceMembers: [] }
  componentWillMount: ->
    window.addEventListener('keydown', this.pressedKey, true)
    $.get pathToWorkspaceID(Canvas.WorkspaceID), (resp) => @setState(workspaceMembers: resp.members)
    $.get pathToCurrentUser(), (resp) => Canvas.CurrentUser = resp
  componentWillUnmount: ->
    window.removeEventListener('keydown', this.pressedKey, true)
  componentWillReceiveProps: (nextProps) ->
    @setState({ children: nextProps.item.children }) if nextProps.item && nextProps.item.children
  handleClick: (event) ->
    return if event.clientY < 52
    if @state.selectedIndex > -1 then @setState({ selectedIndex: -1 }) else this.addItem(event.clientX - 200, event.clientY)
  mouseUp: (event) ->
    i = @state.children[@state.dragIndex]
    @setState({ dragIndex: -1 })
    return if !i
    path = '/api/v1/user/items/' + i.id
    $.ajax path,
      type: 'PATCH'
      data: { position_top: i.position_top, position_left: i.position_left }
      success: -> return
  mouseMove: (event) ->
    return if @state.dragIndex < 0
    event.preventDefault()  # Prevent highlighting other things
    i = @state.children[@state.dragIndex]
    i.position_top = event.clientY
    i.position_left = event.clientX - 200 - @state.dragDiff
    c = @state.children
    c[@state.dragIndex] = i
    @setState({ children: c })
  addItemOfType: (type) ->
    return if type != 'Note'
    # Default, blank note item size is 10x33
    allItems = $('.RootItem').children('.Item')
    minLeft = minTop = 1000000
    for item in allItems
      p = $(item).position()
      minLeft = p.left if p.left < minLeft
      minTop = p.top if p.top < minTop
    MIN_REQ_LEFT_OFFSET = 26  # 10px width + 8px margin on sides
    MIN_REQ_TOP_OFFSET = 101   # 33px height + 8px margin on sides + 52px header
    if minLeft >= MIN_REQ_LEFT_OFFSET || minTop >= MIN_REQ_TOP_OFFSET
      this.addItem(8, 60)
      return
    # Just add to top left for now
    this.addItem(8, 60)
    # No space in top left, so calculate available loc
    # closest to top left
    # if minTop >= MIN_REQ_TOP_OFFSET
    # else if minLeft >= MIN_REQ_LEFT_OFFSET
  addItem: (x, y) ->
    child = {
      position_top: y
      position_left: x
      is_root: false
      latest_content: {
        version: 0
        type: 'Note'
      }
    }
    currChildren = @state.children
    currIndex = currChildren.length
    currChildren.push(child)
    @setState({ children: currChildren, selectedIndex: currIndex })
    $.post '/api/v1/user/items',
      item: child,
      parent_id: @props.item.id
      (resp) =>
        child.id = resp.id
        currChildren = @state.children
        currChildren[currIndex] = child
        @setState({ children: currChildren })
  removeSelectedItem: ->
    children = @state.children
    i = children.splice(@state.selectedIndex, 1)
    @setState({ children: children, selectedIndex: -1 })
    return if i.length < 1 || !i[0].id
    i = i[0]  # Get first element out of array — removed item
    path = '/api/v1/user/items/' + i.id
    $.ajax path,
      type: 'DELETE'
      success: -> console.log('Deleted item with id ' + i.id)
  selectItemAtIndex: (index) ->
    @setState({ selectedIndex: index })
  beginDraggingItemAtIndex: (index, dragX) ->
    i = @state.children[index]
    itemX = i.position_left
    diff = dragX - itemX
    @setState({ dragIndex: index, dragDiff: diff })
  # pressedKey: (event) ->
  #   return if @state.selectedIndex < 0
  #   kc = if event.nativeEvent then event.nativeEvent.keyCode else event.keyCode
  #   return if kc != 8 && kc != 46  # http://stackoverflow.com/a/2353562/472768
  #   if document.activeElement # Editing some text field
  #     event.stopPropagation()
  #   else
  #     event.preventDefault()
  #     this.removeSelectedItem()
  render: ->
    cdn = [Canvas.RootItemHeader({ onAddItem: this.addItemOfType })]
    if @state.children
      cdn.push(Canvas.Item({ item: c, index: i, select: this.selectItemAtIndex, selected: (i == @state.selectedIndex), beginDrag: this.beginDraggingItemAtIndex })) for c, i in @state.children
    selectedItem = null
    if @state.selectedIndex < 0 then selectedItem = null else selectedItem = @state.children[@state.selectedIndex]
    Canvas.SelectedItemID = selectedItem.id if selectedItem != null # For some reason item isn't getting passed
    cdn.push(Canvas.ItemDetails({ itemID: Canvas.SelectedItemID, onRemove: this.removeSelectedItem, members: @state.workspaceMembers })) if @state.selectedIndex >= 0
    React.DOM.div
      className: 'Item RootItem'
      'data-item-id': @props.item.id
      style: { left: @props.item.position_left, top: @props.item.position_top }
      onClick: this.handleClick
      onKeyDown: this.pressedKey
      onMouseMove: this.mouseMove
      onMouseUp: this.mouseUp
      children: cdn
Canvas.Item = React.createClass
  didClickHandle: (event) ->
    event.stopPropagation()
    @props.select(@props.index)
  didBeginDrag: (event) ->
    event.stopPropagation()
    @props.beginDrag(@props.index, event.clientX - 200)
  clickInItem: (event) ->
    event.stopPropagation()
  render: ->
    React.DOM.div
      className: 'Item' + (if @props.selected then ' Selected' else '')
      'data-item-id': @props.item.id
      style: { left: @props.item.position_left, top: @props.item.position_top }
      onClick: this.clickInItem
      children: [
        Canvas.DragHandle({ onClick: this.didClickHandle, onMouseDown: this.didBeginDrag })
        Canvas[@props.item.latest_content.type]({ item: @props.item })
      ]

Canvas.Unknown = React.createClass
  render: ->
    React.DOM.div
      className: 'Unknown'
Canvas.Container = React.createClass
  render: ->
    if !@props.item || !@props.item.latest_content  # AJAX hasn't loaded yet
      return React.DOM.div({})
    React.DOM.div
      className: @props.item.latest_content.type
      'data-version': @props.item.latest_content.version
Canvas.Note = React.createClass
  componentDidMount: ->
    @refs.note.getDOMNode().focus()
  finishEditing: ->
    text = $(@refs.note.getDOMNode()).text()
    itemID = $(@refs.note.getDOMNode()).parent().data('item-id')
    path = '/api/v1/user/items/' + itemID
    $.ajax path,
      type: 'PATCH'
      data: { text: text }
      success: -> return
  pressedKey: (event) ->
    event.stopPropagation() # Prevent backspace/delete from bubbling up to root
  render: ->
    if !@props.item || !@props.item.latest_content  # AJAX hasn't loaded yet
      return React.DOM.div({})
    React.DOM.div
      ref: 'note'
      className: @props.item.latest_content.type
      'data-version': @props.item.latest_content.version
      contentEditable: true
      # children: @props.text
      children: @props.item.latest_content.content || ''
      onBlur: this.finishEditing
      onKeyUp: this.pressedKey