class ClientBonusController < ApplicationController
  before_action :set_client_bonu, only: [:show, :update, :destroy]

  # GET /client_bonus
  def index
    @client_bonus = ClientBonu.all

    render json: @client_bonus
  end

  # GET /client_bonus/1
  def show
    render json: @client_bonu
  end

  # POST /client_bonus
  def create
    @client_bonu = ClientBonu.new(client_bonu_params)

    if @client_bonu.save
      render json: @client_bonu, status: :created, location: @client_bonu
    else
      render json: @client_bonu.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /client_bonus/1
  def update
    if @client_bonu.update(client_bonu_params)
      render json: @client_bonu
    else
      render json: @client_bonu.errors, status: :unprocessable_entity
    end
  end

  # DELETE /client_bonus/1
  def destroy
    @client_bonu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_bonu
      @client_bonu = ClientBonu.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_bonu_params
      params.require(:client_bonu).permit(:current, :added_bonus, :client_id, :bonus)
    end
end
