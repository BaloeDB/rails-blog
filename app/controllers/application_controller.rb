class ApplicationController < ActionController::Base
    helper_method :current_user_session, :current_user
    before_action :require_login, :require_permission
  
    private
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end
  
      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

    private
      def require_login
        unless current_user != nil
          flash[:error] = "You must be logged in to access this section"
          redirect_to new_user_session_path # halts request cycle
        end
      end


    # This should work for multiple types of objects (user, comment, post)
    private
      def require_permission
        @id = params[:id]
        if !@id.nil?
          @post = Post.find(@id)
          unless current_user.id != @post.id
            flash[:error] = "You don't have permissions for this action"
            redirect_to @post # halts request cycle
          end
        end
      end

    protected
    def handle_unverified_request
        # raise an exception
        fail ActionController::InvalidAuthenticityToken
        # or destroy session, redirect
        if current_user_session
        current_user_session.destroy
        end
        redirect_to root_url
    end

end
