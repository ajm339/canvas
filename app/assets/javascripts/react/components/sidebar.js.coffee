# Create namespace for our components
# New namespace if nothing exists yet
# to avoid polluting the global namespace
window.Canvas or= {}
window.Canvas.ITEM_TYPES = ['Note', 'Event', 'File', 'Task', 'Message']
# Create components under our namespace
Canvas.ItemAddButton = React.createClass
  render: ->
    React.DOM.li
      className: 'ItemAddButton',
      children: [
        React.DOM.span
          className: 'Icon'
          children: window['ICON_' + Canvas.ITEM_TYPES[@props.index].toUpperCase()]
        React.DOM.p
          className: 'ItemAddButtonLabel'
          children: Canvas.ITEM_TYPES[@props.index]
      ]
Canvas.ItemAddList = React.createClass
  render: ->
    React.DOM.ul
      id: 'itemAddList',
      children: Canvas.ItemAddButton(index:num) for num in [0...Canvas.ITEM_TYPES.length]
Canvas.Sidebar = React.createClass
  render: ->
    React.DOM.section 
      className: 'Sidebar',
      id: 'sidebar',
      children: [
        React.DOM.h1
          className: 'SidebarPrompt'
          children: 'Add new item'
        Canvas.ItemAddList()
      ]