class DistrictsController < ApplicationController
  before_action :set_district, only: [:show, :update, :destroy, :edit]

  # GET /districts
  def index
    if current_user.admin?
      @districts = District.all
    elsif current_user.provider?
      provider = Provider.where(user: current_user).first
      @districts = District.where(provider_id: provider)
    elsif current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      @districts = District.where(provider_id: manager.provider)
    end

    json = []

    @districts.each do |district|
      json.push(correct_json(district))
    end

    render json: json
  end

  # GET /districts/1
  def show
    render json: correct_json(@district)
  end

  def new
    clients = Client.all

    json = []
    clients.each do |client|
      shops = Shop.where(client: client)
      json.push({id: client.id, user: client.user, date_of_birth: client.date_of_birth, shops: shops})
    end

    render json: json
  end

  def edit
    clients = Client.all

    json = []
    clients.each do |client|
      shops = Shop.where(client: client)
      json.push({id: client.id, user: client.user, date_of_birth: client.date_of_birth, shops: shops})
    end

    render json: {clients: json, district: @district}
  end

  # POST /districts
  def create
    @district = District.new(district_params)

    if @district.save
      render json: correct_json(@district), status: :created, location: @district
    else
      render json: @district.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /districts/1
  def update
    if @district.update(district_params)
      render json: correct_json(@district)
    else
      render json: @district.errors, status: :unprocessable_entity
    end
  end

  # DELETE /districts/1
  def destroy
    @district.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_district
      @district = District.find(params[:id])
    end

    def correct_json(district)
      clients = []

      district.clients.each do |client_id|
        shops = Shop.where(client_id: client_id)
        client = Client.find(client_id)
        client_json = {
                        id: client.id,
                        user: client.user,
                        date_of_birth: client.date_of_birth,
                        shops: shops
                      }
        clients.push(client_json)
      end

      return {
        id: district.id,
        name: district.name,
        provider: district.provider,
        clients: clients,
        created_at: district.created_at,
        updated_at: district.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def district_params
      params.require(:district).permit(:name, :provider_id, clients: [])
    end
end
