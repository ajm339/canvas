module Api
  module V1
    class WorkspacesController < ApiController
      before_filter :can_access?
      before_filter :valid_workspace?, only: [:show, :update]
      respond_to :json

      def index
        respond_with current_user.workspaces.to_a
      end
      def show
        respond_with Workspace.find(params[:id])
      end
      def create
        w = Workspace.create_with_user_id(workspace_params, current_user.id)
        render json: { id: w.id }
      end
      def update
        w = Workspace.find(params[:id])
        success = w.update_attributes(params[:workspace])
        render json: { id: w.id, success: success }
      end
      def destroy
        w = Workspace.find(params[:id])
        w.destroy
        render json: { success: 1 }
      end

      private
      def valid_workspace?
        render json: { status: 404 } if Member.find_by_user_id_and_workspace_id(current_user.id, params[:workspace_id] || params[:id]).blank?
      end

      def workspace_params
        params.require(:workspace).permit(:name)
      end
    end
  end
end