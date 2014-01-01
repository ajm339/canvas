window.Canvas or= {}
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
Canvas.RootItem = React.createClass
  getInitialState: ->
    # TODO: Get root item here, rather than in ItemsContainer
    if !@props.item 
      return { left: 0, top: 0, children: [], selectedIndex: -1, dragIndex: -1, dragDiff: 0 }
    else
      return { left: 0, top: 0, children: @props.item.children || [], selectedIndex: -1, dragIndex: -1, dragDiff: 0 }
  componentWillMount: ->
    window.addEventListener('keydown', this.pressedKey, true)
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
      success: -> console.log('Updated location of item with id ' + i.id)
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
    console.log('minLeft: ' + minLeft + ',minTop: ' + minTop)
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
    console.log('Adding item at ' + x + ',' + y)
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
    @setState({ children: currChildren })
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
  pressedKey: (event) ->
    return if @state.selectedIndex < 0
    kc = if event.nativeEvent then event.nativeEvent.keyCode else event.keyCode
    return if kc != 8 && kc != 46  # http://stackoverflow.com/a/2353562/472768
    event.preventDefault()  # Prevent backspace from navigating page
    this.removeSelectedItem()
  render: ->
    cdn = [Canvas.RootItemHeader({ onAddItem: this.addItemOfType })]
    if @state.children
      cdn.push(Canvas.Item({ item: c, index: i, select: this.selectItemAtIndex, selected: (i == @state.selectedIndex), beginDrag: this.beginDraggingItemAtIndex })) for c, i in @state.children
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
      success: -> console.log('Updated text of item with id ' + itemID)
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