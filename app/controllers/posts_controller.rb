# Should only be able to edit and delete your own posts

class PostsController < ApplicationController
    def index
        @posts = Post.all
        @user = current_user.login
        @session = current_user_session
    end

    def show
        @post = Post.find(params[:id])
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
        @post.destroy

        redirect_to root_path, status: :see_other
    end

    private
        def post_params
            params.require(:post).permit(:title, :body)
        end
end
