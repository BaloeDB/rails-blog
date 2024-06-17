class UsersController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    
    def index
      @users = User.all
    end
  
    def show
      @user = User.find(params[:id])
    end
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
  
      if @user.save
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
  
      if @user.update(user_params)
        redirect_to @recipe
      else
        render :user, status: :unprocessable_entity
      end
    end
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
  
      redirect_to root_path, status: :see_other
    end
  
    private
      def user_params
        params.require(:user).permit(:login, :password, :email, :password_confirmation)
      end

    private
      def write_access_user
        @user = Post.find(params[:id])
        unless current_user.id == @user.id
          flash[:error] = "You don't have permissions for this action"
          redirect_to @post # halts request cycle
        end
      end
  end