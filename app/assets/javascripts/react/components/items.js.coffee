window.Canvas or= {}
Canvas.DragHandle = React.createClass
  getInitialState: ->
    return { isDragging: false, xOffset: 0 }
  mouseDown: ->
    mouseX = event.clientX - 200
    itemX = @props.item.position_left
    diff = mouseX - itemX
    @setState({ isDragging: true, xOffset: diff })
  mouseUp: ->
    @setState({ isDragging: false })
  mouseMove: (event) ->
    return if !@state.isDragging
    @props.updateLocation(event.clientX - 200 - @state.xOffset, event.clientY)
  render: ->
    React.DOM.div
      className: 'ItemDragHandle'
      onMouseDown: this.mouseDown
      onMouseUp: this.mouseUp
      onMouseMove: this.mouseMove
Canvas.Item = React.createClass
  getInitialState: ->
    if !@props.item
      return { left: 0, top: 0 }
    else
      return { left: @props.item.position_left, top: @props.item.position_top }
  componentWillMount: ->
    if @props.item
      @setState({ left: @props.item.position_left, top: @props.item.position_top })
  componentDidMount: (node) ->
    if !@props.isLast
      return
    # Need to focus on contents
    # http://stackoverflow.com/a/3305469/472768
    $(node).contents().focus()
  updateLocation: (x, y) ->
    @setState({ left: x, top: y})
  render: ->
    if !@props.item  # AJAX hasn't loaded yet
      return React.DOM.div({})
    children = []
    if !@props.item.is_root
      children = [
        Canvas.DragHandle({ item:@props.item, updateLocation:this.updateLocation })
        # dot property can be accessed like a key-value array
        Canvas[@props.item.latest_content.type]({ item: @props.item })
      ]
    else
      children = [
        Canvas[@props.item.latest_content.type]({ item: @props.item })
      ]
    
    if @props.item.children
      _t = this
      # Recursively render all children Items. API should set limit on depth of recursion
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