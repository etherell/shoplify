class CheckoutController < ApplicationController

  def create
    @session = Stripe::Checkout::Session.create({
      # Gets customer email to checkout
      customer: current_user.stripe_customer_id,
      # Sets payment method types
      payment_method_types: ['card'],
      line_items: @cart.map { |item| item.to_builder.attributes! },
      allow_promotion_codes: true,
      mode: 'payment',
      # Redirect after success
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      # Redirect after failure
      cancel_url: cancel_url,
    })
    respond_to do |format|
      format.js
    end
  end

  def success
    return redirect_to cancel_url, alert: 'No info to display' if params[:session_id].blank?

    session[:cart] = []
    @session_with_expand = Stripe::Checkout::Session.retrieve({id: params[:session_id], expand: ["line_items"]})
    @session_with_expand.line_items.data.each do |line_item|
      product = Product.find_by(stripe_product_id: line_item.price.product)
    end
  end

  def cancel
  end
end
