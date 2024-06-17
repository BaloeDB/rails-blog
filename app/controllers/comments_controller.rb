class CommentsController < ApplicationController
    skip_before_action :require_permission, only: [:show]

    def index
        @post = Post.find(params[:post_id])
        @comments = @post.comments
    end

    def show
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:comment_id])
        @user = User.find(@post.user_id).login
        @can_edit = @comment.user == current_user
    end

    def new
        @post = Post.find(params[:post_id])
        @comment = @post.comments.new
    end

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.create(body: comment_params[:body], post: @post, user: current_user)

        if @comment.save
            redirect_to post_path(@post)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:comment_id])
    end

    def update
        @post = Post.find(params[:post_id])

        if @comment.update(body: comment_params[:body], post: @post, user: current_user)
            redirect_to @post
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:comment_id])
        @comment.destroy

        redirect_to @post, status: :see_other
    end

    private
        def comment_params
            params.require(:comment).permit(:body)
        end
end
