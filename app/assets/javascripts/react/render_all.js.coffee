window.Canvas or= {}
window.Canvas.ITEM_TYPES = ['Note', 'Event', 'File', 'Task', 'Message']
Canvas.ItemsContainer = React.createClass
  getInitialState: ->
    $.get '/api/v1/user/root_item?show_children=1', (resp) =>
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