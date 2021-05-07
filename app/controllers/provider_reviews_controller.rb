class ProviderReviewsController < ApplicationController
  before_action :set_provider_review, only: [:show, :update, :destroy]

  # GET /provider_reviews
  def index
    @provider_reviews = ProviderReview.all

    render json: @provider_reviews
  end

  # GET /provider_reviews/1
  def show
    render json: @provider_review
  end

  # POST /provider_reviews
  def create
    @provider_review = ProviderReview.new(provider_review_params)

    if @provider_review.save
      render json: @provider_review, status: :created, location: @provider_review
    else
      render json: @provider_review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /provider_reviews/1
  def update
    if @provider_review.update(provider_review_params)
      render json: @provider_review
    else
      render json: @provider_review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /provider_reviews/1
  def destroy
    @provider_review.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_review
      @provider_review = ProviderReview.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def provider_review_params
      params.require(:provider_review).permit(:user_id, :body, :liked_users, :disliked_users, :provider_id)
    end
end
