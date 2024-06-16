class PostsController < ApplicationController
    def index
        @user = current_user.login
        @session = current_user_session
    end
end
