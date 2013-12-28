window.Canvas or= {}
Canvas.Item = React.createClass
  componentDidMount: (node) ->
    if !@props.isLast
      return
    # Need to focus on contents
    # http://stackoverflow.com/a/3305469/472768
    $(node).contents().focus()
  render: ->
    if !@props.item  # AJAX hasn't loaded yet
      return React.DOM.div({})
    children = [
      # dot property can be accessed like a key-value array
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
      style: { left: @props.item.position_left, top: @props.item.position_top}
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