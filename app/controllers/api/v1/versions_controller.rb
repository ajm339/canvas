# require 'api_controller'
module Api
  module V1
    class VersionsController < ApiController
      before_filter :can_access?
      before_filter :valid_item?
      before_filter :valid_version?
      respond_to :json

      def index
        respond_with Item.find(params[:item_id]).item_contents
      end
      def show
        if params[:id] == 'latest'
          if params[:item_id].blank?
            respond_with current_user.root_item.latest_content
          else
            respond_with Item.find(params[:item_id]).latest_content
          end
          return
        end
        if params[:id].to_s[0].casecmp('v').zero?
          # Requesting a version
          respond_with Item.find(params[:item_id]).item_contents.where(version: params[:id].to_s[1..-1]) || nil
        else
          respond_with ItemContent.find(params[:id])
        end
      end

      def root
        respond_with current_user.root_item.item_contents
      end
    end
  end
end