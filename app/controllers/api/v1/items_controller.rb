# require 'api_controller'
module Api
  module V1
    class ItemsController < ApiController
      before_filter :can_access?
      before_filter :valid_item?, only: [:show, :destroy]
      respond_to :json

      def index
        respond_with current_user.followed_items
      end
      def show
        respond_with Item.find(params[:id])
      end
      def create
        i = Item.create_with_params_and_parent_for_user(params[:item], params[:parent_id], current_user.id)
        render json: { id: i.id }
      end
      def destroy
        # TODO: Once we have more database room
        # just mark items as hidden
        # rather than deleting all the records
        i = Item.find(params[:id])
        i.item_contents.to_a.each do |a| a.destroy end
        Collection.where(item_id: params[:id]).to_a.each do |a| a.destroy end
        Follower.find_by_item_id_and_user_id(params[:id], current_user.id).destroy
        Permission.find_by_item_id_and_user_id(params[:id], current_user.id).destroy
        i.destroy
        render json: { success: 1 }
      end

      def root
        respond_with current_user.root_item
      end
    end
  end
end