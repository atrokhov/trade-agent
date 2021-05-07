require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url, as: :json
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { bestseller: @product.bestseller, buy_with: @product.buy_with, characteristics: @product.characteristics, description: @product.description, discount: @product.discount, name: @product.name, novelty: @product.novelty, price: @product.price, price_with_discount: @product.price_with_discount, provider_id: @product.provider_id, rate: @product.rate, status: @product.status, subcategory_id: @product.subcategory_id } }, as: :json
    end

    assert_response 201
  end

  test "should show product" do
    get product_url(@product), as: :json
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { bestseller: @product.bestseller, buy_with: @product.buy_with, characteristics: @product.characteristics, description: @product.description, discount: @product.discount, name: @product.name, novelty: @product.novelty, price: @product.price, price_with_discount: @product.price_with_discount, provider_id: @product.provider_id, rate: @product.rate, status: @product.status, subcategory_id: @product.subcategory_id } }, as: :json
    assert_response 200
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product), as: :json
    end

    assert_response 204
  end
end
