class Admin::CommentsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @comments = Comment.page(params[:page]).per(10).order(created_at: :desc)
    end

    def destroy
        @comment = Comment.find(params[:id]).order(created_at: :desc)
        @comment.destroy
        redirect_to admin_post_path(@comment.post.id)
    end

    private

    def comment_params
     params.require(:comment).permit(:comment_content, :post_id)
    end
end
