require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @user = users(:two)
  end

  test "index_success: should show products" do
    get api_v1_products_path, as: :json
    assert_response 200

    # 测试分页
    json_response = JSON.parse(response.body, symbolize_names:true)
		assert_not_nil json_response.dig(:links, :first)
		assert_not_nil json_response.dig(:links, :last)
		assert_not_nil json_response.dig(:links, :prev)
		assert_not_nil json_response.dig(:links, :next)
  end

  test "show_success: should show product" do
    get api_v1_product_path(@product), as: :json
    json_response = JSON.parse(self.response.body, symbolize_names:true)
    # 验证状态码
    assert_response 200
    # 验证返回数据
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)
  end

  test "create_success: should create product" do
    # 验证某个值变化了
    assert_difference('Product.count', 1) do
      post api_v1_products_path, 
        headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
        params: {product:{title:'firtst test', price:1, published:1}},
        as: :json
    end

    assert_response 201
  end

  test "update_success: should update product" do
    put api_v1_product_path(@product), 
      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
      params: {product:{title:'firtst test', price:1, published:1}},
      as: :json
  
    assert_response 202
  end

  test "update_forbiden: forbidden update product cause unonwer" do
    put api_v1_product_path(@product), 
      headers: { Authorization: JsonWebToken.encode(user_id: users(:one).id) },
      params: {product:{title:'firtst test', price:1, published:1}},
      as: :json
  
    assert_response 403
  end

  test "destroy_success: should destroy product" do
    # 验证某个值变化了
    assert_difference('Product.count', -1) do
      delete api_v1_product_path(@product), 
        headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
        as: :json
    end

    assert_response 204
  end

  test "destroy_forbidden: forbidden destroy product cause unowner" do
    delete api_v1_product_path(@product), 
      headers: { Authorization: JsonWebToken.encode(user_id: users(:one).id) },
      as: :json
    
    assert_response 403
  end
end
