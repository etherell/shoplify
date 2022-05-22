class Product < ApplicationRecord
  validates :name, :price, presence: true

  def to_s
    name
  end

  def to_builder
    Jbuilder.new do |product|
      product.price stripe_price_id
      product.quantity 1
    end
  end

  after_create do
    # Creates product inside stripe
    product = Stripe::Product.create(name: name)
    # Creates price for stripe product (product can have many prices)
    price = Stripe::Price.create(product: product, unit_amount: self.price, currency: 'usd')
    # Adds stripe product id and stripe_price_id to DB
    update(stripe_product_id: product.id, stripe_price_id: price.id)
  end
end
