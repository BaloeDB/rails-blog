class CommentsController < ApplicationController
    before_action :write_access_comment
    skip_before_action :write_access_comment, only: [:new]

    def new
        @post = Post.find(params[:post_id])
        @comment = @post.comments.new
    end

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.create(body: comment_params[:body], user: current_user)

        if @comment.save
            redirect_to post_path(@post)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
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
        @comment = @post.comments.find(params[:id])
        @comment.destroy

        redirect_to @post, status: :see_other
    end

    private
        def comment_params
            params.require(:comment).permit(:body)
        end

    private
      def write_access_comment
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        unless current_user.id == @comment.user.id
          flash[:error] = "You don't have permissions for this action"
          redirect_to @post # halts request cycle
        end
      end
end
