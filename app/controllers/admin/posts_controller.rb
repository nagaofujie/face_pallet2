class Admin::PostsController < ApplicationController
    
def index
    @posts=Post.page(params[:page]).per(8)
end

def show
    @post=Post.find(params[:id])
    @post_tags = @post.tags
end

private

def post_params
    params.require(:post).permit(:title, :introduction, :image)
end

end
