class Public::PostsController < ApplicationController
before_action :authenticate_customer!, only: [:create, :edit, :update, :destroy, :show]

def search_tag 
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.page(params[:id]).per(10)
end

def search
   @result_posts = Post.search(params[:keyword])
   @tag_list = Tag.all
   @keyword = params[:keyword]
   render 'index'
end

def myposts
    @posts = current_customer.posts.page(params[:page]).per(5)
    @customer = current_customer
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
    @posts = Post.page(params[:page]).per(5)
    @tag_list = Tag.page(params[:page]).per(20)
end

def show
    @post = Post.find(params[:id])
    @tags = @post.tags
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(6)
    
end

def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(nil)
end

def update
    @post = Post.find(params[:id])
    tag_list = params[:tag_list].split(nil)

    if @post.update(post_params)
        @old_relations = PostTag.where(post_id: @post.id)
        @old_relations.each do |relation|
            relation.delete
        end
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id)
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
