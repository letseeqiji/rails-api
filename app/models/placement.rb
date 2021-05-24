class Placement < ApplicationRecord
  belongs_to :order
  belongs_to :product, inverse_of: :placements

  after_create :decrement_product_quantity!
  
  private
    def decrement_product_quantity!
      product.decrement!(:quantity, quantity)
    end
end
