window.Canvas or= {}
Canvas.ItemsContainer = React.createClass
  getInitialState: ->
    $.get '/api/v1/user/root_item', (resp) =>
      @setState({ root_item:resp })
      return { root_item: {} }
  addItem: (event) ->
    return false if event.nativeEvent.target.className.indexOf('RootItem') < 0
    item = @state.root_item
    console.log('client:' + event.clientX + ',' + event.clientY)
    console.log('page:' + event.pageX + ',' + event.pageY)
    console.log('screen:' + event.screenX + ',' + event.screenY)
    child = {
      position_top: event.clientY
      position_left: event.clientX - 200  # Account for sidebar width
      is_root: false
      latest_content: {
        version: 0
        type: 'Note'
      }
    }
    if !item.children
      item.children = [child]
    else
      item.children.push(child)
    @setState({ root_item:item })
    # TODO: Save item to server
  render: ->
    React.DOM.div
      id: 'items'
      children: Canvas.Item({ item: @state.root_item, onClick: this.addItem })
Canvas.CanvasContainer = React.createClass
  render: ->
    React.DOM.div
      id: 'container'
      children: [
        Canvas.Sidebar()
        Canvas.ItemsContainer()
      ]
React.renderComponent(Canvas.CanvasContainer(), document.body)