# require 'api_controller'
module Api
  module V1
    class ItemsController < ApiController
      before_filter :can_access?
      before_filter :valid_item?, only: [:show]
      respond_to :json

      def index
        respond_with current_user.followed_items
      end
      def show
        respond_with Item.find(params[:id])
      end

      def root
        respond_with current_user.root_item
      end
    end
  end
end