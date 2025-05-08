class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :initialize_session
  before_action :load_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :admin_user?
  helper_method :get_quantity

  def admin_user?
    user_signed_in? && current_user.admin?
  end

  def require_admin_user
    if !user_signed_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to user_session_path
    elsif !current_user.admin?
      flash[:alert] = "You must be an admin to perform that action"
      redirect_to root_path
    end
  end

  def get_quantity(product_id)
    product = session[:cart].select { |c| c["id"] == product_id }.first
    product["quantity"]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name ])
  end

  private

  def initialize_session
    session[:cart] ||= [] # empty cart = empty array
  end

  def load_cart
    ids = []
    session[:cart].each { |s| ids << s["id"] }
    @cart = Product.where(id: ids)
    session[:cart].each do |s|
      product = @cart.select { |c| c[:id] == s["id"] }.first
      if s["quantity"].to_i > product[:stock]
        s["quantity"] = product[:stock]
        if product[:stock] > 0
          flash.now[:alert] = "#{product[:title]} quantity has been reduced in your cart"
        end
      end
    end
    items_to_remove = @cart.select { |product| product[:available] == false || product[:stock] == 0 }
    if items_to_remove.present?
      @cart = @cart.select { |product| product[:available] == true && product[:stock] > 0 }
      items_to_remove.each do |product|
        session[:cart].delete_if { |c| c["id"] == product[:id] }
        flash.now[:alert] = "#{product[:title]} has been removed from your cart"
      end
    end
  end
end
