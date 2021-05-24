require "test_helper"

class Api::V1::ShopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    @user_5 = users(:five)
  end
  
  test "index_success: should show shops" do
    get api_v1_shops_path, as: :json
    assert_response 200

    # 测试分页
    json_response = JSON.parse(response.body, symbolize_names:true)
		assert_not_nil json_response.dig(:links, :first)
		assert_not_nil json_response.dig(:links, :last)
		assert_not_nil json_response.dig(:links, :prev)
		assert_not_nil json_response.dig(:links, :next)
  end

  test "show_success: should show shop" do
    get api_v1_shop_path(@shop), as: :json
    json_response = JSON.parse(self.response.body)
    # 验证状态码
    assert_response 200
    # 验证返回数据
    assert_equal @shop.name, json_response['data']['attributes']['name']
  end

  test "create_success: should create shop with token" do
    # 验证某个值变化了
    assert_difference('Shop.count', 1) do
      post api_v1_shops_path, 
        headers: { Authorization: JsonWebToken.encode(user_id: @user_5.id) },
        params: {shop:{name:'shop_name', products_count:10, orders_count:10}},
        as: :json
    end

    assert_response 201
  end
    
  test "create_forbiden: should not create shop without token" do
    post api_v1_shops_path, 
      params: {shop:{name:'shop_name', products_count:10, orders_count:10}},
      as: :json
    assert_response 401
  end

  test "update_success: should update shop with owner" do
    put api_v1_shop_path(@shop), 
      headers: { Authorization: JsonWebToken.encode(user_id: @shop.user.id) },
      params: {shop:{name:'shop_name', products_count:10, orders_count:10}},
      as: :json
  
    assert_response 201
  end

  test "update_forbidden: forbidden update shop without owner" do
    put api_v1_shop_path(@shop), 
      headers: { Authorization: JsonWebToken.encode(user_id: @user_5.id) },
      params: {shop:{name:'shop_name', products_count:10, orders_count:10}},
      as: :json
  
    assert_response 403
  end

  test "delete_success: should delete shop with owner" do
    assert_difference('Shop.count', -1) do
      delete api_v1_shop_path(@shop), 
        headers: { Authorization: JsonWebToken.encode(user_id: @shop.user.id) },
        as: :json
    end
  
    assert_response 204
  end

  test "delete_forbidden: forbidden delete shop without owner" do
    delete api_v1_shop_path(@shop), 
      headers: { Authorization: JsonWebToken.encode(user_id: @user_5.id) },
      as: :json
  
    assert_response 403
  end
end
