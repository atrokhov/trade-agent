require 'test_helper'

class BasketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @basket = baskets(:one)
  end

  test "should get index" do
    get baskets_url, as: :json
    assert_response :success
  end

  test "should create basket" do
    assert_difference('Basket.count') do
      post baskets_url, params: { basket: { agent_id: @basket.agent_id, client_id: @basket.client_id, count: @basket.count, product_id: @basket.product_id } }, as: :json
    end

    assert_response 201
  end

  test "should show basket" do
    get basket_url(@basket), as: :json
    assert_response :success
  end

  test "should update basket" do
    patch basket_url(@basket), params: { basket: { agent_id: @basket.agent_id, client_id: @basket.client_id, count: @basket.count, product_id: @basket.product_id } }, as: :json
    assert_response 200
  end

  test "should destroy basket" do
    assert_difference('Basket.count', -1) do
      delete basket_url(@basket), as: :json
    end

    assert_response 204
  end
end
