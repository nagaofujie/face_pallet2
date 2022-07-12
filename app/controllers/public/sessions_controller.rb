# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_permited_parameters
  before_action :customer_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]
 
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to homes_top_path, notice: 'successfully logged in as a guest'
  end
  
  private
  
    def after_sign_in_path_for(resource)
          homes_top_path
    end
    
    def after_sign_out_path_for(resource)
          homes_top_path
    end


   protected
   
  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email])
    return if !@customer
     if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted
       redirect_to new_customer_session_path
     end
  end
  
   
  def configure_permited_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  end
end
