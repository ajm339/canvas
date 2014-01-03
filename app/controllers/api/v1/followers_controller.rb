module Api
  module V1
    class FollowersController < ApiController
      before_filter :can_access?
      before_filter :valid_item?
      respond_to :json

      def index
        respond_with Item.find(params[:item_id]).following_users
      end
    end
  end
end