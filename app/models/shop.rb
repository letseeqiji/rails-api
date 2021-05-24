class Shop < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy

  validates :name, presence: true,
            uniqueness: true,
            format: { with: /\w+[a-zA-Z]{3,9}/ }
  validates :products_count, numericality: { only_integer: true}
  validates :orders_count, numericality: { only_integer: true }
  validates :user_id, uniqueness: true
  validate :user_can_not_be_admin, on: :create
  
  def user_can_not_be_admin
    if user.role == 0
      errors.add(:user_id, "can't be admin")
    end
  end
end
