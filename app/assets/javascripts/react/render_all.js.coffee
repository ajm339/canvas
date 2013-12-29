window.Canvas or= {}
window.Canvas.ITEM_TYPES = ['Note', 'Event', 'File', 'Task', 'Message']
Canvas.ItemAddButton = React.createClass
  render: ->
    React.DOM.div
      className: 'ItemAddButton'
      # id: Canvas.ITEM_TYPE[@props.index].toLowerCase() + 'Filter'
      children:
        React.DOM.span
          className: 'Icon'
          children: window['ICON_' + Canvas.ITEM_TYPES[@props.index].toUpperCase()]
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
              children: Canvas.ItemAddButton(index: num) for num in [0...Canvas.ITEM_TYPES.length]
          ]
      ]
Canvas.ItemsContainer = React.createClass
  getInitialState: ->
    $.get '/api/v1/user/root_item?show_children=1', (resp) =>
      @setState({ root_item:resp })
    return { root_item: {} }
  render: ->
    React.DOM.div
      id: 'items'
      children: [
        Canvas.RootItemHeader()
        Canvas.RootItem({ item: @state.root_item })
      ]
  
Canvas.CanvasContainer = React.createClass
  render: ->
    React.DOM.div
      id: 'container'
      children: [
        Canvas.Sidebar()
        Canvas.ItemsContainer()
      ]
React.renderComponent(Canvas.CanvasContainer(), document.body)