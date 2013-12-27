# require 'api_controller'
module Api
  module V1
    class UsersController < ApiController
      before_filter :can_access?
      respond_to :json

      def show
        respond_with current_user
      end
    end
  end
end