class CheckoutController < ApplicationController

  def create
    product = Product.find(params[:id])
    @session = Stripe::Checkout::Session.create({
      # Gets customer email to checkout
      customer: current_user.stripe_customer_id,
      # Sets payment method types
      payment_method_types: ['card'],
      line_items: [{
        # Sets product information to session
        price: product.stripe_price_id,
        quantity: 1
      }],
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
  end

  def cancel
  end
end
