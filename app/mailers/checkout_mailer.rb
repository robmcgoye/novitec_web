class CheckoutMailer < ApplicationMailer
  before_action :initialize_order
  helper_method :get_quantity

  def order_email(user, order_session, address)
    @user = user
    load_order(order_session)
    @address = address
    mail(to: @user.email, subject: "Thanks for your order request at Novi-Tec")
  end

  def new_order_email(user, order_session, address)
    @user = user
    load_order(order_session)
    @address = address
    mail(to: Rails.application.credentials.dig(:smtp, :new_orders_email_to), reply_to: user.email, subject: "New order to process")
  end

  def get_quantity(product_id)
    product = @cart_order.select { |c| c["id"] == product_id }.first
    product["quantity"]
  end

  private

  def initialize_order
    @cart_order ||= [] # empty cart = empty array
  end

  def load_order(session)
    @cart_order = session
    ids = []
    @cart_order.each { |s| ids << s["id"] }
    @order = Product.where(id: ids)
  end
end
