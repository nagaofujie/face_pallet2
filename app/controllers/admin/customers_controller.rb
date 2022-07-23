class Admin::CustomersController < ApplicationController
     before_action :authenticate_admin!
def index
    @customers=Customer.page(params[:page]).per(10)
end 

def show
    @customer=Customer.find(params[:id])
    @comments=@customer.comments.page(params[:page]).per(10)
end

private

def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :image)
end

end

