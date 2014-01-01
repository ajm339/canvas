# Create namespace for our components
# New namespace if nothing exists yet
# to avoid polluting the global namespace
window.Canvas or= {}
# Create components under our namespace
Canvas.SidebarProfile = React.createClass
  getInitialState: ->
    $.get '/api/v1/user', (resp) =>
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
Canvas.WorkspaceList = React.createClass
  getInitialState: ->
    return { workspaces: [] }
  componentWillMount: ->
    $.get '/api/v1/user/workspaces', (resp) =>
      @setState({ workspaces: resp })
  selectWorkspace: (event) ->
    e = event.nativeEvent
    if (e.target) 
      targ = e.target
    else if (e.srcElement) 
      targ = e.srcElement
    if (targ.nodeType == 3)
      targ = targ.parentNode;
    workspaceID = $(targ).data('workspace-id') || $(targ).parent('.Workspace').data('workspace-id')
    @props.onSelectWorkspace(workspaceID)
  render: ->
    workspaceList = []
    if @state.workspaces
      _t = this
      workspaceList = @state.workspaces.map((wksp) ->
        return React.DOM.li
          className: 'Workspace'
          'data-workspace-id': wksp.id
          onClick: _t.selectWorkspace
          children: 
            React.DOM.h2
              className: 'WorkspaceName',
              children: wksp.name
      )
    workspaceList.push(
      React.DOM.li
        id: 'createWorkspacePrompt'
        children: 'Create a workspace'
    )
    React.DOM.section
      id: 'workspaces'
      children: [
        React.DOM.h1
          id: 'workspacesHeader'
          children: 'Workspaces'
        React.DOM.ol
          id: 'workspaceList'
          children: workspaceList
      ]
Canvas.Workspace = React.createClass
  getInitialState: ->
    return { name: '' }
  componentWillMount: ->
    $.get ('/api/v1/user/workspaces/' + @props.id), (resp) =>
      @setState(name: resp.name)
  render: ->
    React.DOM.section
      id: 'currentWorkspace'
      children: [
        React.DOM.span
          className: 'Icon'
          id: 'workspaceBack'
          onClick: @props.onBack
          children: ICON_LEFT_ANGLE_ROUND;
        React.DOM.h1
          className: 'WorkspaceName'
          children: @state.name
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
      ]

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
  getInitialState: ->
    return { workspaceID: getCookie('workspaceID') || -1 }
  selectWorkspace: (id) ->
    setCookie('workspaceID', id, 7300)
    @setState(workspaceID: id)
  showAllWorkspaces: ->
    console.log('showAllWorkspaces')
    setCookie('workspaceID', -1, 7300)
    @setState(workspaceID: -1)
  render: ->
    console.log('render sidebar')
    children = [Canvas.SidebarProfile(), Canvas.SidebarSearch()]
    if !getCookie('workspaceID') || getCookie('workspaceID') == '-1'
      children.push(Canvas.WorkspaceList({ onSelectWorkspace: this.selectWorkspace }))
    else
      children.push(Canvas.Workspace({ id: getCookie('workspaceID'), onBack: this.showAllWorkspaces }))
    children.push(Canvas.SidebarFooter())
    React.DOM.section 
      className: 'Sidebar',
      id: 'sidebar',
      children: children