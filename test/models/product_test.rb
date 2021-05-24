require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @p_one = products(:one)
  end

  # 使用合法参数
  test 'valid: product with all valid things' do
    product = Product.new(title:"title123", price:1, published:1, shop_id:@p_one.shop.id, published:1)
    assert product.valid?
  end

  test 'invalid: product with invalid title' do
    product = Product.new(title:"", price:1, published:1, shop_id:@p_one.shop.id, published:1)
    assert_not product.valid?
  end

  test 'invalid: product with taken title and shop_id' do
    product = Product.new(title:@p_one.title, price:1, published:1, shop_id:@p_one.shop.id, published:1)
    assert_not product.valid?
  end

  test 'invalid: product with invalid published' do
    product = Product.new(title:'firtst test', price:1, published:1, shop_id:@p_one.shop.id, published:2)
    assert_not product.valid?
  end

  test 'invalid: product with invalid price' do
    product = Product.new(title:'firtst test', price:-100, published:1, shop_id:@p_one.shop.id, published:1)
    assert_not product.valid?
  end
end
