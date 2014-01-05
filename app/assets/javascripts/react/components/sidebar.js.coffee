# Create namespace for our components
# New namespace if nothing exists yet
# to avoid polluting the global namespace
window.Canvas or= {}
# Create components under our namespace
Canvas.WorkspaceID = getCookie('workspaceID') || -1
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
    return { workspaces: [], isCreating: false }
  componentWillMount: ->
    $.get '/api/v1/user/workspaces', (resp) =>
      @setState({ workspaces: resp })
  componentDidUpdate: ->
    return if !@refs || !@refs.newWorkspace
    @refs.newWorkspace.getDOMNode().focus()
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
  createWorkspace: ->
    @setState(isCreating: true)
  keyDown: (event) ->
    return if !@state.isCreating || !@refs.newWorkspace
    nwkps = @refs.newWorkspace
    kc = if event.nativeEvent then event.nativeEvent.keyCode else event.keyCode
    return if kc != 13  # Return key
    workspace = {
      name: $(@refs.newWorkspace.getDOMNode()).text()
    }
    $.post '/api/v1/user/workspaces',
      workspace: workspace
      (resp) =>
        wksps = @state.workspaces
        lastWksp = wksps[wksps.length - 1]
        lastWksp.id = resp.id
        wksps[wksps.length - 1] = lastWksp
        @setState(workspaces: wksps)
    event.preventDefault()
    workspace.name = '' # Fix display issue with double lines
    wksps = @state.workspaces
    wksps.push(workspace)
    @setState({ workspaces: wksps, isCreating: false })
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
    if @state.isCreating
      console.log('adding ref')
      workspaceList.push(
        React.DOM.li
          className: 'Workspace'
          contentEditable: true
          ref: 'newWorkspace'
          onKeyDown: this.keyDown
      )
    else
      workspaceList.push(
        React.DOM.li
          id: 'createWorkspacePrompt'
          onClick: this.createWorkspace
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
    return { name: '', members: [] }
  componentWillMount: ->
    $.get ('/api/v1/user/workspaces/' + @props.id), (resp) =>
      @setState(name: resp.name, members: resp.members.concat(resp.invites))
  addMember: (event) ->
    event.preventDefault()
    # TODO: Don't create/add/send invite if email already exists
    form = @refs.addMemberForm.getDOMNode()
    fname = $(form).children('#invite_fname').val()
    lname = $(form).children('#invite_lname').val()
    email = $(form).children('#invite_email').val()
    invite = {
      target_fname: fname
      target_lname: lname
      target_email: email
    }
    $.post '/api/v1/user/invite',
      invite: invite
    member = { id: -1, name: fname + ' ' + lname }
    members = @state.members
    members.push(member)
    @setState({ members: members })
    $(form).children('#invite_fname').val('')
    $(form).children('#invite_lname').val('')
    $(form).children('#invite_email').val('')
  showInviteBlock: ->
    $('#inviteMembers').slideDown()
  render: ->
    members = @state.members.map((m) ->
      name = m.display_name.split(' ')
      initials = name[0].slice(0,1) + name[1].slice(0,1)
      c = 'SidebarProfilePicture Small WorkspaceMemberProfilePicture'
      c = c + ' Inactive' if m.id < 0
      return (React.DOM.div
        className: c
        children: initials
      )
    )
    members.push(
      React.DOM.div
        className: 'AddWorkspaceMember'
        onClick: this.showInviteBlock
        children: 
          React.DOM.span
            className: 'Icon'
            children: ICON_PLUS
    )
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
          children: 'Members'
        React.DOM.div
          className: 'WorkspaceMembers'
          children: members
        React.DOM.div
          id: 'inviteMembers'
          children: [
            React.DOM.p
              id: 'addWorkspaceMemberPrompt'
              children: ('Add member to ' + @state.name)
            React.DOM.form
              ref: 'addMemberForm'
              id: 'addWorkspaceMember'
              onSubmit: this.addMember
              children: [
                React.DOM.input
                  className: 'Small'
                  type: 'text'
                  placeholder: 'First name'
                  required: true
                  name: 'invite[fname]'
                  id: 'invite_fname'
                React.DOM.input
                  className: 'Small'
                  type: 'text'
                  placeholder: 'Last name'
                  required: true
                  name: 'invite[lname]'
                  id: 'invite_lname'
                React.DOM.input
                  className: 'Small'
                  type: 'email'
                  placeholder: 'Email address'
                  required: true
                  name: 'invite[email]'
                  id: 'invite_email'
                React.DOM.input
                  className: 'Small'
                  type: 'submit'
                  id: 'invite_button'
                  value: 'Invite'
              ]
          ]
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
    Canvas.WorkspaceID = id
    @setState(workspaceID: id)
  showAllWorkspaces: ->
    setCookie('workspaceID', -1, 7300)
    @setState(workspaceID: -1)
  render: ->
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