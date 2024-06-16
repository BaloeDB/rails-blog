class PostsController < ApplicationController
    skip_before_action :require_permission, only: [:show]

    def index
        @posts = Post.all
    end

    def show
        @post = Post.find(params[:id])
        @user = User.find(@post.user_id).login
        @can_edit = @post.user == current_user
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(title: post_params[:title], body: post_params[:body], user: current_user)

        if @post.save
            redirect_to @post
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        @post = Post.new(title: post_params[:title], body: post_params[:body], user: current_user)

        if @post.update(post_params)
            redirect_to @post
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post = Post.find(params[:id])
        if current_user.id != @post.user_id
            redirect_to @post
        end
        @post.destroy

        redirect_to root_path, status: :see_other
    end

    private
        def post_params
            params.require(:post).permit(:title, :body)
        end
end
