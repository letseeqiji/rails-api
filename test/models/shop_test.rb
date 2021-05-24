require "test_helper"

class ShopTest < ActiveSupport::TestCase
  test 'valid: shop with all valid things' do
    shop = Shop.new(name: 'shoptest01', products_count:0, orders_count:1)
    shop.user = users(:four)
    assert shop.valid?
  end

  test 'invalid: shop with taken name' do
    shop = Shop.new(name: shops(:one).name, products_count:0, orders_count:1)
    shop.user = users(:five)
    assert_not shop.valid?
  end

  test 'invalid: shop with invalid user_id' do
    shop = Shop.new(name: 'shoptest02', products_count:0, orders_count:1)
    shop.user = users(:one)
    assert_not shop.valid?
  end

  test 'invalid: shop with taken user_id' do
    puts shops(:one).user
    @shop = Shop.new(name: 'shoptest03', products_count:0, orders_count:1)
    # byebug
    @shop.user = shops(:one).user
    assert_not @shop.valid?
  end

  test 'invalid: shop with invalid products_count' do
    shop = Shop.new(name: 'shoptest04', products_count:0, orders_count:1.55)
    shop.user = users(:six)
    assert_not shop.valid?
  end
end
