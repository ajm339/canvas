window.Canvas or= {}
Canvas.ItemCount = 0
Canvas.ItemsContainer = React.createClass
  getInitialState: ->
    $.get '/api/v1/user/root_item', (resp) =>
      @setState({ root_item:resp })
    return { root_item: {} }
  render: ->
    React.DOM.div
      id: 'items'
      children: Canvas.RootItem({ item: @state.root_item })
  
Canvas.CanvasContainer = React.createClass
  render: ->
    React.DOM.div
      id: 'container'
      children: [
        Canvas.Sidebar()
        Canvas.ItemsContainer()
      ]
React.renderComponent(Canvas.CanvasContainer(), document.body)