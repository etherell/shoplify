class Product < ApplicationRecord
  validates :name, :price, presence: true

  def to_s
    name
  end

  after_create do
    # Creates product inside stripe
    product = Stripe::Product.create(name: name)
    # Creates price for stripe product (product can have many prices)
    price = Stripe::Price.create(product: product, unit_amount: self.price, currency: 'usd')
    # Adds stripe product id to DB
    update(stripe_product_id: product.id)
  end
end
