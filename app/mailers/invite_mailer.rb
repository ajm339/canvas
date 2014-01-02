class InviteMailer < ActionMailer::Base
  default from: "Canvas <welcome@getcanvas.io>"

  def invite_email(invite)
    @fname = invite.target_fname
    @lname = invite.target_lname
    @email = invite.target_email
    @email_with_name = "#{ @fname } #{ @lname } <#{ @email }>"
    @code = invite.code
    @workspace = invite.workspace.name
    @sender_name = invite.user.display_name
    @link = "http://www.getcanvas.io/join?email=#{ @email }&code=#{ @code }"
    mail to: @email_with_name, subject: "#{ @sender_name } invited you to Canvas"
  end
end
