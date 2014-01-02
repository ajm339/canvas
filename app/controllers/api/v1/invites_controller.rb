# require 'api_controller'
module Api
  module V1
    class InvitesController < ApiController
      before_filter :can_access?
      respond_to :json

      def create
        success = 0
        if User.find_by_email(invite_params[:email]).blank?
          i = Invite.new(invite_params)
          i.accepted = false
          i.code = SecureRandom.urlsafe_base64
          i.user = current_user
          i.workspace = Workspace.find(cookies[:workspaceID])
          i.save
          i.invite
          success = 1
        end
        render json: { success: success }
      end

      private
      def invite_params
        params.require(:invite).permit(:target_fname, :target_lname, :target_email)
      end
    end
  end
end