class User < ApplicationRecord
  has_one :shop, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\w+@\w+\.{1}[a-zA-Z]{2,}/ }
	validates :password_digest, presence: true
	validates :role,  inclusion: { in: [0, 1, 2], message:"role can be only in [0 1 2]" }
  
  has_secure_password
end
