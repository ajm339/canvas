# require 'api_controller'
module Api
  module V1
    class UsersController < ApiController
      before_filter :can_access?
      respond_to :json

      def index
        respond_with User.all
      end
      def show
        respond_with User.find(params[:id])
      end
    end
  end
end