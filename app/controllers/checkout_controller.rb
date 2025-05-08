class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def index
    if @cart.length > 0
      @address = Address.new
    else
      redirect_to cart_index_path
    end
  end

  def create
    @address = Address.new(address_params)
    if @address.valid?
      # send email
      CheckoutMailer.order_email(current_user, session[:cart], @address).deliver_now
      CheckoutMailer.new_order_email(current_user, session[:cart], @address).deliver_now
      render "success"
      session[:cart] = [] # empty cart = empty array
    else
      render "index"
    end
  end

  def success
  end

  def cancel
    flash[:notice] = "Checkout was canceled."
    redirect_to root_path
  end

  private

  def address_params
    params.require(:address).permit(:address_line_1, :address_line_2, :city,
                              :state, :zip, :save_user_address)
  end
end
