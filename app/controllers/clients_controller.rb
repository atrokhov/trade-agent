class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :edit, :destroy, :block]

  # GET /clients
  def index
    @clients = Client.all

    correct_clients = []

    @clients.each do |client|
      correct_clients.push(correct_json(client))
    end

    render json: correct_clients
  end

  # GET /clients/1
  def show
    render json: correct_json(@client)
  end

  def new
    if current_user.admin?
      users = User.where(role: nil)
    end

    render json: {users: users}
  end

  def edit
    if current_user.admin?
      users = User.where(role: nil)
      json = {users: users, client: client}
    elsif current_user.client? and @client.user == current_user
      json = {client: client}
    end

    render json: json
  end

  # POST /clients
  def create
    if current_user.role == nil
      @client = Client.new(client_params)
      @client.user = current_user
      current_user.role = :client
      current_user.save!
    elsif current_user.admin?
      @client = Client.new(client_params)
      user = User.find(client_params[:user_id])
      user.role = :client
      user.save!
    end

    if @client.save
      render json: correct_json(@client), status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def block
    if current_user.admin?
      user = User.find(@client.user_id)
      user.blocked = true
      user.save!
    end
    render json: correct_json(@client)
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render json: correct_json(@client)
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    def correct_json(client)
      shops = Shop.where(client_id: client.id)
      
      if client.avatar.attached?
        avatar = url_for(client.avatar)
      else
        avatar = nil
      end

      if client.patent.attached?
        patent = url_for(client.patent)
      else
        patent = nil
      end

      if client.passport.attached?
        passport = url_for(client.passport)
      else
        passport = nil
      end

      if client.certificate.attached?
        certificate = url_for(client.certificate)
      else
        certificate = nil
      end

      return {
        id: client.id,
        avatar: avatar,
        patent: patent,
        passport: passport,
        certificate: certificate,
        city: client.city,
        user: client.user,
        date_of_birth: client.date_of_birth,
        client_type: client.client_type,
        shops: shops,
        created_at: client.created_at,
        updated_at: client.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.permit(:user_id, :date_of_birth, :city, :client_type, :avatar, :patent, :passport, :certificate)
    end
end
