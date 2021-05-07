require 'test_helper'

class ProviderBonusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_bonu = provider_bonus(:one)
  end

  test "should get index" do
    get provider_bonus_url, as: :json
    assert_response :success
  end

  test "should create provider_bonu" do
    assert_difference('ProviderBonu.count') do
      post provider_bonus_url, params: { provider_bonu: { bonus: @provider_bonu.bonus, intent: @provider_bonu.intent, provider_id: @provider_bonu.provider_id } }, as: :json
    end

    assert_response 201
  end

  test "should show provider_bonu" do
    get provider_bonu_url(@provider_bonu), as: :json
    assert_response :success
  end

  test "should update provider_bonu" do
    patch provider_bonu_url(@provider_bonu), params: { provider_bonu: { bonus: @provider_bonu.bonus, intent: @provider_bonu.intent, provider_id: @provider_bonu.provider_id } }, as: :json
    assert_response 200
  end

  test "should destroy provider_bonu" do
    assert_difference('ProviderBonu.count', -1) do
      delete provider_bonu_url(@provider_bonu), as: :json
    end

    assert_response 204
  end
end
