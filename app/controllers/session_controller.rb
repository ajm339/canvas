class SessionController < ApplicationController
  def self.is_logged_in?(request = nil)
    return false if request.blank?
    token = request.cookies[:user_remember]
    return (token.blank?) ? false : true
  end

  def new
  end
end
