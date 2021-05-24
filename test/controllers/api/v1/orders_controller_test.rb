require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
		@order = orders(:one)
    @param = {
      order:{
        products:[
          {id:products(:one).id, quantity:2},
          {id:products(:two).id, quantity:3}
        ]
      }
    }
	end
    
	test 'index_forbidden: should not show orders cause unlogged' do
		get api_v1_orders_url, as: :json
		assert_response 403
	end
    
  test "index_success: should show orders" do
      get api_v1_orders_path, 
          headers: { Authorization: JsonWebToken.encode(user_id:@order.user_id) },
          as: :json
      assert_response 200
      # puts  JSON.parse(response.body, symbolize_names:true)

      # 测试分页
      json_response = JSON.parse(response.body, symbolize_names:true)
      assert_not_nil json_response.dig(:links, :first)
      assert_not_nil json_response.dig(:links, :last)
      assert_not_nil json_response.dig(:links, :prev)
      assert_not_nil json_response.dig(:links, :next)
  end

  test "show_forbidden: should forbidden show order cause unlogin" do
    get api_v1_order_path(@order), as: :json
    # 验证状态码
    assert_response 403
  end
    
  test "show_success: should show order" do
    get api_v1_order_path(@order),
      headers: { Authorization: JsonWebToken.encode(user_id:@order.user_id) },
      as: :json
    json_response = JSON.parse(self.response.body, symbolize_names:true)
    # 验证状态码
    assert_response 200
    # 验证返回数据
    assert_equal @order.price_total, json_response.dig(:data, :attributes, :price_total)
  end

  test "create_forbidden: should forbidden create order cause unlogin" do
    post api_v1_orders_path, as: :json
    # 验证状态码
    assert_response 403
  end
    
  test "create_success: should create order" do
    post api_v1_orders_path,
      headers: { Authorization: JsonWebToken.encode(user_id:@order.user_id) },
      params: @param,
      as: :json
    json_response = JSON.parse(self.response.body, symbolize_names:true)
    # 验证状态码
    assert_response 201
    # 验证返回数据
    assert_equal @order.price_total, json_response.dig(:data, :attributes, :price_total)
    assert_equal products(:one).quantity-2, 8
    assert_equal products(:two).quantity-3, 7
  end
end
