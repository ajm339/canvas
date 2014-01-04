module Api
  module V1
    class FollowersController < ApiController
      before_filter :can_access?
      before_filter :valid_item?
      respond_to :json

      def index
        respond_with Item.find(params[:item_id]).following_users
      end
      def create
        f = Follower.create(user_id: follower_params[:user_id], item_id: params[:item_id], is_owner: false, can_edit: false)
        render json: { success: f.blank? ? 0 : 1 }
      end

      private
      def follower_params
        params.require(:follower).permit(:user_id)
      end
    end
  end
end