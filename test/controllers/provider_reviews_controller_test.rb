require 'test_helper'

class ProviderReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_review = provider_reviews(:one)
  end

  test "should get index" do
    get provider_reviews_url, as: :json
    assert_response :success
  end

  test "should create provider_review" do
    assert_difference('ProviderReview.count') do
      post provider_reviews_url, params: { provider_review: { body: @provider_review.body, disliked_users: @provider_review.disliked_users, liked_users: @provider_review.liked_users, provider_id: @provider_review.provider_id, user_id: @provider_review.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show provider_review" do
    get provider_review_url(@provider_review), as: :json
    assert_response :success
  end

  test "should update provider_review" do
    patch provider_review_url(@provider_review), params: { provider_review: { body: @provider_review.body, disliked_users: @provider_review.disliked_users, liked_users: @provider_review.liked_users, provider_id: @provider_review.provider_id, user_id: @provider_review.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy provider_review" do
    assert_difference('ProviderReview.count', -1) do
      delete provider_review_url(@provider_review), as: :json
    end

    assert_response 204
  end
end
