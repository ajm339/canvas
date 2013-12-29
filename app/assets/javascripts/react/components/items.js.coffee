window.Canvas or= {}
Canvas.DragHandle = React.createClass
  getInitialState: ->
    return { isDragging: false, xOffset: 0 }
  # mouseClick: ->
  #   @props.select()
  # mouseDown: ->
  #   @props.beginDrag(@props.item)
  render: ->
    React.DOM.div
      className: 'ItemDragHandle'
      onClick: @props.onClick
      onMouseDown: @props.onMouseDown
Canvas.RootItem = React.createClass
  getInitialState: ->
    if !@props.item 
      return { left: 0, top: 0, children: [], selectedIndex: -1, dragIndex: -1, dragDiff: 0 }
    else
      return { left: 0, top: 0, children: @props.item.children || [], selectedIndex: -1, dragIndex: -1, dragDiff: 0 }
  componentWillMount: ->
    window.addEventListener('keydown', this.pressedKey, true)
  componentWillUnmount: ->
    window.removeEventListener('keydown', this.pressedKey, true)
  handleClick: (event) ->
    if @state.selectedIndex > -1 then @setState({ selectedIndex: -1 }) else this.addItem(event.clientX - 200, event.clientY)
  mouseUp: (event) ->
    @setState({ dragIndex: -1 })
  mouseMove: (event) ->
    return if @state.dragIndex < 0
    event.preventDefault()  # Prevent highlighting other things
    i = @state.children[@state.dragIndex]
    i.position_top = event.clientY
    i.position_left = event.clientX - 200 - @state.dragDiff
    c = @state.children
    c[@state.dragIndex] = i
    @setState({ children: c })
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
    currChildren.push(child)
    @setState({ children: currChildren })
  removeSelectedItem: ->
    children = @state.children
    children.splice(@state.selectedIndex, 1)
    @setState({ children: children, selectedIndex: -1 })
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
    cdn = []
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
  # getInitialState: ->
  #   return { left: @props.item.position_left, top: @props.item.position_top }
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
      children: ''
      onKeyUp: this.pressedKey