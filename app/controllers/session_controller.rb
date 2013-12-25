class SessionController < ApplicationController
  def self.is_logged_in?(request = nil)
    return false if request.blank?
    token = request.cookie_jar.signed[:user_remember]
    return (User.find_by_remember_token(token).blank?) ? false : true
  end

  def new
  end

  def matches?(request)
    return !SessionController.is_logged_in?(request)
  end
end