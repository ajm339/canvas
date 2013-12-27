window.Canvas or= {}
Canvas.Item = React.createClass
  render: ->
    type = if @props.item then @props.item.latest_content.type else 'Unknown'
    style = if @props.item then { left: @props.item.position_left, top: @props.item.position_top} else { left: 0, top: 0 }
    React.DOM.div
      className: 'Item'
      style: style
      children: [
        Canvas[type]({ item: @props.item })  # dot property can be accessed like a key-value array
      ]

Canvas.Unknown = React.createClass
  render: ->
    React.DOM.div
      className: 'Unknown'
Canvas.Container = React.createClass
  render: ->
    React.DOM.div
      className: @props.item.latest_content.type
      'data-version': @props.item.latest_content.version
      children: 'This is a ' + @props.item.latest_content.type + ' thing'