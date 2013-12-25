# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('body').on('click', '#toggleSignup', ->
  $('#login_user').css('display', 'none')
  $('#new_user').css('display', 'block')
  $('#login_signup').addClass('Expand')
  # setTimeout((->
  $('#newUserName').slideDown()
  # ), 0)
  $('#toggleSignup').removeClass('Visible')
  $('#toggleLogin').addClass('Visible')
)
$('body').on('click', '#toggleLogin', ->
  $('#login_signup').removeClass('Expand')
  # setTimeout((->
  $('#newUserName').slideUp()
  # ), 0)
  setTimeout((->
    $('#login_user').css('display', 'block')
    $('#new_user').css('display', 'none')
  ), 400)
  $('#toggleSignup').addClass('Visible')
  $('#toggleLogin').removeClass('Visible')
)