require 'session_controller'

class UsersController < ApplicationController
  def join
    redirect_to login_root_path if params[:email].blank? || params[:code].blank?
    @invite = Invite.find_by_target_email_and_code(params[:email], params[:code])
    redirect_to login_root_path if @invite.blank?
  end

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

  def accept
    u = User.create(user_params)
    user_success = (u.blank?) ? 0 : 1
    i = Invite.find_by_target_email_and_code(params[:target_email], params[:code])
    invite_success = (i.blank?) ? 0 : 1
    Member.create(user_id: u.id, workspace_id: i.workspace.id) if !i.blank?
    i.accept = true
    i.save
    login_success = (params[:user][:should_log_in] && save_login(u)) ? 1 : 0
    if user_success && login_success
      redirect_to root_path
    else
      render json: { success:success, invite_success: invite_success, should_log_in:params[:user][:should_log_in], login_success:login_success }
    end
    return true
  end

  def login
    # TODO: Add error messages?
    user = User.find_by_email(params[:user][:email].downcase)
    success = 1
    if !user.blank? && user.authenticate(params[:user][:password])
      save_login(user)
    else
      success = 0
    end
    if success > 0
      redirect_to root_path
    else
      render json: { success: success }
    end
    return (success > 0) ? true : false
  end

  def logout
    u = User.find_by_remember_token(cookies.signed[:user_remember])
    u.create_remember_token
    u.save
    cookies.delete :user_remember
    render json: { success: 1 }
    return true
  end

  private
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :is_guest)
  end

  def save_login(user)
    return false if user.blank?
    # Change remember token on every login
    user.create_remember_token
    user.save
    cookies.permanent.signed[:user_remember] = user.remember_token
    return true
  end
end
