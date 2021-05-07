require 'test_helper'

class InstuctionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instuction = instuctions(:one)
  end

  test "should get index" do
    get instuctions_url, as: :json
    assert_response :success
  end

  test "should create instuction" do
    assert_difference('Instuction.count') do
      post instuctions_url, params: { instuction: { name: @instuction.name } }, as: :json
    end

    assert_response 201
  end

  test "should show instuction" do
    get instuction_url(@instuction), as: :json
    assert_response :success
  end

  test "should update instuction" do
    patch instuction_url(@instuction), params: { instuction: { name: @instuction.name } }, as: :json
    assert_response 200
  end

  test "should destroy instuction" do
    assert_difference('Instuction.count', -1) do
      delete instuction_url(@instuction), as: :json
    end

    assert_response 204
  end
end
