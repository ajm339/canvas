window.Canvas or= {}
Canvas.DragHandle = React.createClass
  getInitialState: ->
    return { isDragging: false, xOffset: 0 }
  mouseDown: ->
    @props.beginDrag(@props.item)
  render: ->
    React.DOM.div
      className: 'ItemDragHandle'
      onMouseDown: this.mouseDown
Canvas.Item = React.createClass
  getInitialState: ->
    if !@props.item then { left: 0, top: 0, currentlyDragging: null, draggingDiff: 0 } else { left: @props.item.position_left, top: @props.item.position_top, currentlyDragging: null, draggingDiff: 0 }
  componentWillMount: ->
    @setState({ left: @props.item.position_left, top: @props.item.position_top }) if @props.item
    # Bind event handler to self
    # https://groups.google.com/forum/#!topic/reactjs/WbKgCGD5zDE
    window.addEventListener('mousemove', this.mouseMove, true)
    window.addEventListener('mouseup', this.mouseUp, true)
  componentWillUnmount: ->
    window.removeEventListener('mousemove', this.mouseMove, true)
    window.removeEventListener('mouseup', this.mouseUp, true)
  componentDidMount: (node) ->
    return if !@props.isLast
    # Need to focus on contents, not just element
    # http://stackoverflow.com/a/3305469/472768
    $(node).contents().focus()
  beginDrag: (item) ->
    mouseX = event.clientX - 200
    itemX = @state.left
    diff = mouseX - itemX
    @setState({ currentlyDragging: item, draggingDiff: diff })
  endDrag: (item) ->
    @setState({ currentlyDragging: null, draggingDiff: 0 })
  mouseMove: (event) ->
    return if !@state.currentlyDragging
    @setState({ left: event.clientX - 200 - @state.draggingDiff, top: event.clientY })
  mouseUp: (event) ->
    @endDrag(@state.currentlyDragging) if @state.currentlyDragging
  updateLocation: (x, y) ->
    @setState({ left: x, top: y})
  render: ->
    return React.DOM.div({}) if !@props.item  # AJAX hasn't loaded yet
    children = []
    if !@props.item.is_root  # Add drag handle if item isn't root
      children = [
        Canvas.DragHandle({ item:@props.item, updateLocation:this.updateLocation, beginDrag:this.beginDrag, endDrag:this.endDrag })
        # dot property can be accessed like a key-value array
        Canvas[@props.item.latest_content.type]({ item: @props.item })
      ]
    else
      children = [
        Canvas[@props.item.latest_content.type]({ item: @props.item })
      ]
    
    if @props.item.children
      # Recursively render all children Items. API should set limit on depth of recursion
      _t = this
      `for (var i = 0; i < this.props.item.children.length; i++) {
        is_last = (i === this.props.item.children.length - 1) ? true : false;
        children.push(Canvas.Item({ item: this.props.item.children[i], onClick: _t.props.onClick, isLast: is_last }));
      }`
    React.DOM.div
      className: 'Item' + (if @props.item && @props.item.is_root then ' RootItem' else '')
      'data-item-id': @props.item.id
      style: { left: @state.left, top: @state.top}
      onClick: @props.onClick
      children: children

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
  render: ->
    if !@props.item || !@props.item.latest_content  # AJAX hasn't loaded yet
      return React.DOM.div({})
    React.DOM.div
      className: @props.item.latest_content.type
      'data-version': @props.item.latest_content.version
      contentEditable: true
      children: ''