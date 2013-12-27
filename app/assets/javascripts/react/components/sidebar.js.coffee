# Create namespace for our components
# New namespace if nothing exists yet
# to avoid polluting the global namespace
window.Canvas or= {}
# window.Canvas.ITEM_TYPES = ['Note', 'Event', 'File', 'Task', 'Message']
# Create components under our namespace
Canvas.SidebarProfile = React.createClass
  getInitialState: ->
    $.get '/api/v1/user', (resp) =>
      console.log('Get initial state')
      @setState({ user:resp })
      return { user: {} }
  render: ->
    initials = if this.state.user then this.state.user.fname.slice(0,1) + this.state.user.lname.slice(0,1) else ''
    name = if this.state.user then this.state.user.display_name else ''
    React.DOM.div
      className: 'SidebarProfile'
      children: [
        React.DOM.div
          className: 'SidebarProfilePicture'
          children: initials
        React.DOM.p
          className: 'SidebarProfileName'
          children: name
      ]
Canvas.SidebarSearch = React.createClass
  render: ->
    React.DOM.div
      className: 'SidebarSearch'
      children:
        React.DOM.input
          type: 'text'
          placeholder: 'Search everything'

Canvas.FILTER_TYPES = ['Event', 'Task', 'File', 'Message']
Canvas.SidebarFilterButton = React.createClass
  render: ->
    React.DOM.li
      className: 'Filter'
      id: Canvas.FILTER_TYPES[@props.index].toLowerCase() + 'Filter'
      children:
        React.DOM.span
          className: 'Icon'
          children: window['ICON_' + Canvas.FILTER_TYPES[@props.index].toUpperCase()]
Canvas.SidebarFilter = React.createClass
  render: ->
    React.DOM.div
      id: 'sidebarFilters'
      children:
        React.DOM.ul
          className: 'SidebarHorizontalList'
          id: 'filtersList'
          children: Canvas.SidebarFilterButton(index: num) for num in [0...Canvas.FILTER_TYPES.length]

Canvas.SidebarFooter = React.createClass
  logout: ->
    # Coffeescript syntax for AJAX:
    # http://coffeescriptcookbook.com/chapters/jquery/ajax
    $.get '/logout', (resp) ->
        window.location = '/'
  render: ->
    React.DOM.footer
      className: 'SidebarInset'
      id: 'sidebarFooter'
      children: [
        React.DOM.span
          className: 'Icon'
          id: 'sidebarSettingsIcon'
          children: window['ICON_SETTING']
        React.DOM.span
          className: 'Icon'
          id: 'sidebarLogoutIcon'
          onClick: this.logout
          children: window['ICON_POWER']
      ]

Canvas.Sidebar = React.createClass
  render: ->
    React.DOM.section 
      className: 'Sidebar',
      id: 'sidebar',
      children: [
        # Canvas.ItemAddList()
        Canvas.SidebarProfile()
        Canvas.SidebarSearch()
        React.DOM.h1
          className: 'SidebarPrompt'
          children: 'Pinned items'
        React.DOM.p
          id: 'noPinnedItems'
          children: 'No pinned items'
        React.DOM.h1
          className: 'SidebarPrompt'
          children: 'Filter items'
        Canvas.SidebarFilter()
        Canvas.SidebarFooter()
      ]