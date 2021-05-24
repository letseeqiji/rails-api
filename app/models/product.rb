class Product < ApplicationRecord
  belongs_to :shop
  has_many :placements, dependent: :destroy
	has_many :orders, through: :placements

  validates :title, presence: true
	validates :price, presence: true,  numericality: { only_integer: true, greater_than_or_equal_to:0 }
  validates :published, inclusion: { in: [0, 1], message:"role can be only in [0 1]" }
  validate :title_cannot_be_taken_in_self_shop

  private
    def title_cannot_be_taken_in_self_shop
      if self.class.exists?(title: title, shop_id: shop_id)
        errors.add(title, "title cannot be taken in self shop")
      end
    end
end
