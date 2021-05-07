require 'test_helper'

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = providers(:one)
  end

  test "should get index" do
    get providers_url, as: :json
    assert_response :success
  end

  test "should create provider" do
    assert_difference('Provider.count') do
      post providers_url, params: { provider: { address: @provider.address, category_id: @provider.category_id, description: @provider.description, name: @provider.name, phone: @provider.phone, status: @provider.status, user_id: @provider.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show provider" do
    get provider_url(@provider), as: :json
    assert_response :success
  end

  test "should update provider" do
    patch provider_url(@provider), params: { provider: { address: @provider.address, category_id: @provider.category_id, description: @provider.description, name: @provider.name, phone: @provider.phone, status: @provider.status, user_id: @provider.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy provider" do
    assert_difference('Provider.count', -1) do
      delete provider_url(@provider), as: :json
    end

    assert_response 204
  end
end
