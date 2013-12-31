require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should post to /users to create and redirect to root" do
    assert_difference('User.count') do
      post :create, user: { fname: 'Jon', lname: 'Smith', email: 'jon@smith.com', password: 'abc'}
    end
    assert_redirected_to root_path
  end
  test "should redirect to root with valid login" do
    u = create_random_user
    post :login, user: { email: u.email, password: 'letmein' }
    assert_redirected_to root_path
  end
  test "valid login should change remember token" do
    u = create_random_user
    rt = u.remember_token
    post :login, user: { email: u.email, password: 'letmein' }
    assert_not_equal rt, User.find(u.id).remember_token
  end
  test "valid login should set user_remember cookie" do
    u = create_random_user
    post :login, user: { email: u.email, password: 'letmein' }
    assert !cookies.signed[:user_remember].blank?
    assert_equal cookies.signed[:user_remember], User.find(u.id).remember_token
  end
  test "should render json success 0 with invalid login" do
    post :login, user: { email: 'doesnotexist@fake.com' }
    assert @response.body.include? '"success":0'
  end
  test "logout should change remember token and clear cookie" do
    u = create_random_user
    rt = u.remember_token
    post :login, user: { email: u.email, password: 'letmein' }
    rt2 = User.find(u.id).remember_token
    assert_not_equal rt, rt2
    get :logout
    assert_not_equal rt, rt2
    assert cookies.signed[:user_remember].blank?
  end
end
