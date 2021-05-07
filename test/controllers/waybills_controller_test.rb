require 'test_helper'

class WaybillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @waybill = waybills(:one)
  end

  test "should get index" do
    get waybills_url, as: :json
    assert_response :success
  end

  test "should create waybill" do
    assert_difference('Waybill.count') do
      post waybills_url, params: { waybill: { addresses: @waybill.addresses, provider_id: @waybill.provider_id, status: @waybill.status } }, as: :json
    end

    assert_response 201
  end

  test "should show waybill" do
    get waybill_url(@waybill), as: :json
    assert_response :success
  end

  test "should update waybill" do
    patch waybill_url(@waybill), params: { waybill: { addresses: @waybill.addresses, provider_id: @waybill.provider_id, status: @waybill.status } }, as: :json
    assert_response 200
  end

  test "should destroy waybill" do
    assert_difference('Waybill.count', -1) do
      delete waybill_url(@waybill), as: :json
    end

    assert_response 204
  end
end
