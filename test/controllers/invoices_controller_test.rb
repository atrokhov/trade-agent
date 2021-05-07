require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get invoices_url, as: :json
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post invoices_url, params: { invoice: { address: @invoice.address, client_id: @invoice.client_id, provider_id: @invoice.provider_id, status: @invoice.status, waybill_id: @invoice.waybill_id } }, as: :json
    end

    assert_response 201
  end

  test "should show invoice" do
    get invoice_url(@invoice), as: :json
    assert_response :success
  end

  test "should update invoice" do
    patch invoice_url(@invoice), params: { invoice: { address: @invoice.address, client_id: @invoice.client_id, provider_id: @invoice.provider_id, status: @invoice.status, waybill_id: @invoice.waybill_id } }, as: :json
    assert_response 200
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete invoice_url(@invoice), as: :json
    end

    assert_response 204
  end
end
