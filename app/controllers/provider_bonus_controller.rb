class ProviderBonusController < ApplicationController
  before_action :set_provider_bonu, only: [:show, :update, :destroy]

  # GET /provider_bonus
  def index
    @provider_bonus = ProviderBonu.all

    render json: @provider_bonus
  end

  # GET /provider_bonus/1
  def show
    render json: @provider_bonu
  end

  # POST /provider_bonus
  def create
    @provider_bonu = ProviderBonu.new(provider_bonu_params)

    if @provider_bonu.save
      render json: @provider_bonu, status: :created, location: @provider_bonu
    else
      render json: @provider_bonu.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /provider_bonus/1
  def update
    if @provider_bonu.update(provider_bonu_params)
      render json: @provider_bonu
    else
      render json: @provider_bonu.errors, status: :unprocessable_entity
    end
  end

  # DELETE /provider_bonus/1
  def destroy
    @provider_bonu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_bonu
      @provider_bonu = ProviderBonu.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def provider_bonu_params
      params.require(:provider_bonu).permit(:provider_id, :intent, :bonus)
    end
end
