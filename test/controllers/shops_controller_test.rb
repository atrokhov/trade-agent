require 'test_helper'

class ShopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
  end

  test "should get index" do
    get shops_url, as: :json
    assert_response :success
  end

  test "should create shop" do
    assert_difference('Shop.count') do
      post shops_url, params: { shop: { address: @shop.address, city: @shop.city, client_id: @shop.client_id, name: @shop.name, type: @shop.type } }, as: :json
    end

    assert_response 201
  end

  test "should show shop" do
    get shop_url(@shop), as: :json
    assert_response :success
  end

  test "should update shop" do
    patch shop_url(@shop), params: { shop: { address: @shop.address, city: @shop.city, client_id: @shop.client_id, name: @shop.name, type: @shop.type } }, as: :json
    assert_response 200
  end

  test "should destroy shop" do
    assert_difference('Shop.count', -1) do
      delete shop_url(@shop), as: :json
    end

    assert_response 204
  end
end
