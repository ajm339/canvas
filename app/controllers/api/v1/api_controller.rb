module Api
  module V1
    class ApiController < ApplicationController
      private
      def authenticate(remember_token)
        return User.find_by_remember_token(remember_token) || nil
      end
      def can_access?
        render json: { status: 500 } and return false if request.blank?
        render json: { status: 403 } if remember_token.blank? || authenticate(remember_token).blank?
      end
      def remember_token
        return cookies.signed[:user_remember] || params[:user_remember] || nil
      end
      def current_user
        return User.find_by_remember_token(remember_token)
      end
      def valid_item?
        # Return 404 status — give no indication that the item exists
        # regardless of whether it actually does
        render json: { status: 404 } if !current_user.can_see_item_with_id?(params[:item_id] || params[:id])
      end
      def valid_version?
        return if params[:id].to_s[0].casecmp('v').zero?
        i = Item.find(params[:item_id])
        render json: { status: 404 } and return false if i.blank?
        # where on an association:
        # http://stackoverflow.com/a/5227744/472768
        render json: { status: 404 } if i.item_contents.where(id: params[:id]).count < 1
      end
    end
  end
end
