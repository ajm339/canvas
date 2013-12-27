# require 'api_controller'
module Api
  module V1
    class ItemsController < ApiController
      before_filter :can_access?
      respond_to :json

      def index
        respond_with User.find(params[:user_id]).followed_items
      end
      def show
        respond_with Item.find(params[:id])
      end

      def root
        respond_with User.find(params[:user_id]).root_item
      end
    end
  end
end