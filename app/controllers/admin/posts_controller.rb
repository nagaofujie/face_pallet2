class Admin::PostsController < ApplicationController
    before_action :authenticate_admin!
def index
    @posts=Post.page(params[:page]).per(8).order(created_at: :desc)
end

def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @comments = @post.comments
end

def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
end

private

def post_params
    params.require(:post).permit(:title, :introduction, :image)
end

end
