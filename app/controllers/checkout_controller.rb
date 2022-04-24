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
        name: product.name,
        amount: product.price,
        currency: "usd",
        quantity: 1
      }],
      mode: 'payment',
      # Redirect after success
      success_url: root_url,
      # Redirect after failure
      cancel_url: root_url,
    })
    respond_to do |format|
      format.js
    end
  end

end
