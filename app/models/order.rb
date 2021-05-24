class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  before_validation :set_price_total
  
  validates :price_total, presence: true, numericality: { greater_than_or_equal_to: 0}
  validate :enough_products?

  # 创建 订单的 plcaemenent
  def build_order_placement(products)
    products.each do |product|
      placement = placements.build(
        product_id: product[:id],
        quantity: product[:quantity]
      )

      yield placement if block_given?
    end 
  end

  private
    # 自动计算订单总额
    def set_price_total
      self.price_total = placements.map{|placement| placement.product.price*placement.quantity }.sum
    end

    def enough_products?
      self.placements.each do |placement|
        product = placement.product
        if placement.quantity > product.quantity
          errors.add(product.title, "Is out of stock, just #{product.quantity} left")
        end
      end
    end
end
