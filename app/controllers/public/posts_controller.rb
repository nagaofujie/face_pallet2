class Public::PostsController < ApplicationController
before_action :authenticate_customer!, only: [:create, :edit, :update, :destroy, :show]

def search_tag 
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.page(params[:id]).per(10)
end


def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    tag_list = params[:tag_list].split(nil) 
 if @post.save
    @post.save_tag(tag_list)        
    redirect_to posts_path
 else 
    render :new
 end
end

def new
    @post = Post.new
end

def index
    @post = Post.new
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
    @tag_list = Tag.all
end

def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @comment = Comment.new
    @comments = @post.comments
end

def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(nil)
end

def update
    @post = Post.find(params[:id])
    tag_list = params[:tag_list].split(nil)
    if @post.update(post_params)
        if params[:post][:status] == "公開"
        @old_relations = PostTag.where(post_id: @post.id)
        @old_relations.each do |relation|
          relation.delete
        end
       @post.save_tag(tag_list)
       redirect_to post_path(@post.id)
        else
    render :edit
        end
    end
end

def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
end

private

def post_params
  params.require(:post).permit(:image, :title, :introduction)
end

end
