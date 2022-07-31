class Public::CustomersController < ApplicationController
    before_action :authenticate_customer!


def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
    @favorites_count = 0
    @posts.each do |post|
           @favorites_count += post.favorites.count
    end
    @comments_count = 0
        @posts.each do |post|
            @comments_count += post.comments.count
    end
end

def edit
    @customer = current_customer
end

def update
    @customer = current_customer
    if @customer.email == 'guest@example.com'
        redirect_to root_path
    end

    if @customer.update(customer_params)
        redirect_to customer_path(@customer.id)
    else
        render :edit
    end
end

def withdraw
    @customer = current_customer
    if @customer.email == 'guest@example.com'
      redirect_to root_path, notice: "Guest can't be deleted"
    else
    @customer.update(is_deleted: true)
    reset_session
    redirect_to new_customer_session_path
    end
end

def mypage
    @customer = current_customer
    @posts = @customer.posts
        favorites = Favorite.where(customer_id: current_customer.id).pluck(:post_id)
    @favorite_list = Post.find(favorites)

    @favorites_count = 0
    @posts.each do |post|
           @favorites_count += post.favorites.count
    end
    @comments_count = 0
        @posts.each do |post|
            @comments_count += post.comments.count
    end
end



private

def customer_params
    params.require(:customer).permit(:image, :last_name, :first_name)
end

end
