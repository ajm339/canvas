module ApplicationHelper
  def current_user
    uid = session[:uid]
    return (uid.blank?) ? nil : User.find(uid)
  end
end
