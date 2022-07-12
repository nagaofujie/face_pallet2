class Admin::CustomersController < ApplicationController
    
def index
    @customer=Customer.new
    @customers=Customer.page(params[:page]).per(10)
end 

def show
    @customer=Customer.find(params[:id])
    @comments=@customer.comments
end

private

def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email)
end

end

