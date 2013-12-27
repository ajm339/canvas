window.Canvas or= {}
Canvas.ItemsContainer = React.createClass
  render: ->
    React.DOM.div
      id: 'items'
      children: 'Container'
Canvas.CanvasContainer = React.createClass
  render: ->
    React.DOM.div
      id: 'container'
      children: [
        Canvas.Sidebar()
        Canvas.ItemsContainer()
      ]
React.renderComponent(Canvas.CanvasContainer(), document.body)