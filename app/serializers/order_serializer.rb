class OrderSerializer
  include JSONAPI::Serializer
  attributes :price_total
  belongs_to :user
	has_many :products
end
