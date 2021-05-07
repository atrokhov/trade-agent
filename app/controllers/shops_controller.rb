class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :update, :edit, :destroy]

  # GET /shops
  def index
    if current_user.admin?
      @shops = Shop.all
    elsif current_user.client?
      @shops = Shop.where(user: current_user)
    end

    correct_shops = []
    @shops.each do |shop|
      correct_shops.push(correct_json(shop))
    end

    render json: correct_shops
  end

  # GET /shops/1
  def show
    render json: correct_json(@shop)
  end

  def new
    @success_json = []
    if current_user.admin?
      clients = Client.all
      clients.each do |client|
        @success_json.push({id: client.id, user: client.user, date_of_birth: client.date_of_birth, created_at: client.created_at, updated_at: client.updated_at})
      end
    end
    render json: @success_json
  end

  def edit
    @success_json = []
    if current_user.admin?
      clients = Client.all
      clients.each do |client|
        @success_json.push({id: client.id, user: client.user, date_of_birth: client.date_of_birth, created_at: client.created_at, updated_at: client.updated_at})
      end

      json = {clients: @success_json, shop: correct_json(@shop)}
    elsif current_user.client?
      json = correct_json(@shop)
    end
    
    render json: json
  end

  # POST /shops
  def create
    @shop = Shop.new(shop_params)
    if current_user.client? 
      @shop.user = current_user
    end

    if @shop.save
      render json: correct_json(@shop), status: :created, location: @shop
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shops/1
  def update
    if @shop.update(shop_params)
      render json: correct_json(@shop)
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shops/1
  def destroy
    @shop.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    def correct_json(shop)
      return {
        id: shop.id,
        client: {
          id: shop.client.id,
          user: shop.client.user,
          city: shop.client.city,
          client_type: shop.client.client_type,
          date_of_birth: shop.client.date_of_birth
        },
        name: shop.name,
        address: shop.address,
        created_at: shop.created_at,
        updated_at: shop.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def shop_params
      params.require(:shop).permit(:client_id, :name, :address)
    end
end
