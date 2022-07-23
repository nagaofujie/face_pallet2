class Admin::CommentsController < ApplicationController
    before_action :authenticate_admin!
    
    def index
        @comments = Comment.page(params[:page]).per(10)
    end
    
    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to admin_customer_path(@comment.customer.id)
    end
    
    private
    
    def comment_params
     params.require(:comment).permit(:comment_content, :post_id)
    end
end
