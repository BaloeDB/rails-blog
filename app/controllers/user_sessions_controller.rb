class UserSessionsController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    skip_before_action :require_permission
  
    # Somehow this methods get called instead of destroy, why?
    def show
      destroy()
    end
  
    def new
      @user_session = UserSession.new
    end
  
    def create
      @user_session = UserSession.new(user_session_params.to_h)
      if @user_session.save
        redirect_to root_url
      else
        render :new, status: 422
      end
    end
  
    def destroy
      current_user_session.destroy
      redirect_to root_path
    end
  
    private
  
    def user_session_params
      params.require(:user_session).permit(:login, :password, :remember_me)
    end
  end
