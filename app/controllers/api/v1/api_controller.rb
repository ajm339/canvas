module Api
  module V1
    class ApiController < ApplicationController
      private
      def authenticate(remember_token)
        return User.find_by_remember_token(remember_token) || nil
      end
      def can_access?
        render status: 500 if request.blank?
        remember_token = cookies.signed[:user_remember] || params[:user_remember] || nil
        head :forbidden if remember_token.blank? || authenticate(remember_token).blank?
      end
    end
  end
end
