require 'session_controller'

class UsersController < ApplicationController
  def create
    # TODO: Add error messages?
    u = User.create(user_params)
    success = (u.blank?) ? 0 : 1
    login_success = (params[:user][:should_log_in] && save_login(u)) ? 1 : 0
    if success && login_success
      redirect_to root_path
    else
      render json: { success:success, should_log_in:params[:user][:should_log_in], login_success:login_success }
    end
    return true
  end

  def login
    # TODO: Add error messages?
    user = User.find_by_email(params[:user][:email].downcase)
    success = 1
    if user && user.authenticate(params[:user][:password])
      save_login(user)
    else
      success = 0
    end
    if success
      redirect_to root_path
    else
      render json: { success: success }
    end
    return (success > 0) ? true : false
  end

  private
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password)
  end

  def save_login(user)
    return false if user.blank?
    cookies.permanent.signed[:user_remember] = user.remember_token
    return true
  end
end
