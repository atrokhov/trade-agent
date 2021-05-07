class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show, :update, :edit, :destroy, :provider_products, :block]
  before_action :authenticate_user!, except: [:show, :index, :provider_products]

  # GET /providers
  def index
    @providers = []

    Provider.all.each do |provider|
      @providers.push(success_json(provider))
    end
    render json: @providers
  end

  def provider_products
    @products = Product.where(provider: @provider)

    render json: @products
  end

  # GET /providers/1
  def show
    render json: success_json(@provider)
  end

  def new
    if current_user.admin?
      categories = Category.all
      users = User.where(role: nil)
      @json = {categories: categories, users: users}
    elsif current_user.role == nil
      categories = Category.all
      @json = {categories: categories}
    end

    render json: @json
  end

  # POST /providers
  def create
    @provider = Provider.new(provider_params)

    if current_user.role == nil
      @provider.user_id = current_user.id
      current_user.role = :provider
      current_user.save!
    elsif current_user.admin?
      user = User.find(provider_params[:user_id])
      user.role = :provider
      user.save!
    end

    if @provider.save
      render json: success_json(@provider), status: :created, location: @provider
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.admin?
      categories = Category.all
      users = User.where(role: nil)
      @json = {categories: categories, users: users, provider: success_json(@provider)}
    elsif current_user.provider?
      categories = Category.all
      @json = {categories: categories, provider: success_json(@provider)}
    end

    render json: @json
  end  

  # PATCH/PUT /providers/1
  def update
    if @provider.update(provider_params)
      render json: success_json(@provider)
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /providers/1
  def destroy
    @provider.destroy
  end

  def block
    if current_user.admin?
      @provider.status = false
      user = User.find(@provider.user_id)
      user.blocked = true
      user.save!
      @provider.save!

      Product.where(provider: @provider).each do |product|
        product.status = false
        product.save!
      end

      Staff.where(provider: @provider).each do |staff|
        user = User.find(staff.user_id)
        user.blocked = true
        user.save!
      end
    end
  end

  private

    def success_json(provider)
      if provider.logo.attached?
        logo = url_for(provider.logo)
      else
        logo = nil
      end

      return {id: provider.id, logo: logo, name: provider.name, address: provider.address, phone: provider.phone, description: provider.description, status: provider.status, category: provider.category, user: provider.user, created_at: provider.created_at, updated_at: provider.updated_at}
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def provider_params
      params.require(:provider).permit(:name, :address, :phone, :description, :status, :category_id, :user_id)
    end
end
