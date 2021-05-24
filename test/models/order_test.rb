require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @user = users(:one)
  end

  # 使用合法参数
  test 'valid: order with all valid things' do
    order = Order.new(user_id:@user.id, price_total:1)
    assert order.valid?
  end

  # price_total 不需要给参数 是自动计算的 该测试无效
  # test 'invalid: order with invalid price_total' do
  #   order = Order.new(user_id:@user.id, price_total:-1)
  #   assert_not order.valid?
  # end
end
