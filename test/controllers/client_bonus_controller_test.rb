require 'test_helper'

class ClientBonusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_bonu = client_bonus(:one)
  end

  test "should get index" do
    get client_bonus_url, as: :json
    assert_response :success
  end

  test "should create client_bonu" do
    assert_difference('ClientBonu.count') do
      post client_bonus_url, params: { client_bonu: { added_bonus: @client_bonu.added_bonus, bonus: @client_bonu.bonus, client_id: @client_bonu.client_id, current: @client_bonu.current } }, as: :json
    end

    assert_response 201
  end

  test "should show client_bonu" do
    get client_bonu_url(@client_bonu), as: :json
    assert_response :success
  end

  test "should update client_bonu" do
    patch client_bonu_url(@client_bonu), params: { client_bonu: { added_bonus: @client_bonu.added_bonus, bonus: @client_bonu.bonus, client_id: @client_bonu.client_id, current: @client_bonu.current } }, as: :json
    assert_response 200
  end

  test "should destroy client_bonu" do
    assert_difference('ClientBonu.count', -1) do
      delete client_bonu_url(@client_bonu), as: :json
    end

    assert_response 204
  end
end
