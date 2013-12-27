# require 'api_controller'
module Api
  module V1
    class UsersController < ApiController
      before_filter :can_access?
      respond_to :json

      def show
        respond_with User.find_by_remember_token(cookies.signed[:user_remember] || params[:user_remember] || nil)
      end
    end
  end
end