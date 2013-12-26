ITEM_TYPES = ['Note', 'Event', 'File', 'Task', 'Message']
ItemAddButton = React.createClass
  render: ->
    React.DOM.li
      className: 'ItemAddButton',
      children: [
        React.DOM.span
          className: 'Icon'
          children: window['ICON_' + ITEM_TYPES[@props.index].toUpperCase()]
        React.DOM.p
          className: 'ItemAddButtonLabel'
          children: ITEM_TYPES[@props.index]
      ]
ItemAddList = React.createClass
  render: ->
    React.DOM.ul
      id: 'itemAddList',
      children: ItemAddButton(index:num) for num in [0...ITEM_TYPES.length]
Sidebar = React.createClass
  render: ->
    React.DOM.section 
      className: 'Sidebar',
      id: 'sidebar',
      children: [
        React.DOM.h1
          className: 'SidebarPrompt'
          children: 'Add new item'
        ItemAddList()
      ]
React.renderComponent(Sidebar(), document.body)