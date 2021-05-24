class ProductSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :published, :shop_id
  belongs_to :shop
end
