class Public::CommentsController < ApplicationController
    before_action :authenticate_customer!

    
    def create
          @comment = current_customer.comments.new(comment_params)
          @post = @comment.post
        if @comment.save
             redirect_to post_path(@post.id)
        end
    end
    
    private
    
    def comment_params
        params.require(:comment).permit(:comment_content, :post_id)
    
    end
    
end
    