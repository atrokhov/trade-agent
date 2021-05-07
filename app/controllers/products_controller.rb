class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :block]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /products
  def index
    @products = []
    if user_signed_in?
      if current_user.manager?
        manager = Staff.where(user: current_user)
        Product.where(provider: manager.provider).each do |product|
          @products.push(success_json(product))
        end
      elsif current_user.provider?
        provider = Provider.where(user: current_user)
        Product.where(provider: provider).each do |product|
          @products.push(success_json(product))
        end
      end
    else
      Product.all.each do |product|
        @products.push(success_json(product))
      end
    end

    render json: @products
  end

  # GET /products/1
  def show
    render json: success_json(@product)
  end

  def new 
    if current_user.admin?
      subcategories = Subcategory.all
      providers = Provider.all
      @json = { subcategories: subcategories, providers: providers }
    elsif current_user.manager? or current_user.provider?
      subcategories = Subcategory.all
      @json = { subcategories: subcategories }
    end

    render json: @json
  end

  # POST /products
  def create
    if current_user.admin? or current_user.moderator?
      @product = Product.new(product_params)
    elsif current_user.manager?
      @product = Product.new(product_params)
      manager = Staff.where(user: current_user).first
      @product.provider = manager.provider
    elsif current_user.provider?
      @product = Product.new(product_params)
      provider = Provider.where(user: current_user).first
      @product.provider = provider
    end
    
    @product.save_price_with_discount
    if @product.save
      render json: success_json(@product), status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.admin?
      subcategories = Subcategory.all
      providers = Provider.all
      @json = {subcategories: subcategories, providers: providers, product: success_json(@product) }
    elsif current_user.manager? or current_user.provider?
      subcategories = Subcategory.all
      @json = { subcategories: subcategories, product: success_json(@product) }
    end

    render json: @json
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      @product.save_price_with_discount
      @product.save!
      render json: success_json(@product)
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  def block
    if current_user.provider? and @product.provider == Provider.where(user: current_user) or current_user.admin?
      @product.status = false
      @product.save!
    end
  end

  private

    def success_json(product)
      if product.image.attached?
        image = url_for(product.image)
      else
        image = nil
      end

      return {
        id: product.id,
        uuid: product.uuid,
        image: image,
        name: product.name,
        description: product.description,
        subcategory: {
          id: product.subcategory.id,
          name: product.subcategory.name,
          description: product.subcategory.description,
          category: product.subcategory.category
        },
        provider: {
          id: product.provider.id,
          name: product.provider.name, 
          address: product.provider.address, 
          phone: product.provider.phone, 
          description: product.provider.description, 
          status: product.provider.status,
          category: product.provider.category,
          user: product.provider.user
        },
        characteristics: product.characteristics,
        retail_price: product.retail_price,
        wholesale_price: product.wholesale_price,
        retail_discount: product.retail_discount,
        wholesale_discount: product.wholesale_discount,
        retail_price_with_discount: product.retail_price_with_discount,
        wholesale_price_with_discount: product.wholesale_price_with_discount,
        rate: product.rate,
        bestseller: product.bestseller,
        novelty: product.novelty,
        status: product.status,
        buy_with: product.buy_with,
        created_at: product.created_at, 
        updated_at: product.updated_at
      }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :description, :subcategory_id, :provider_id, :characteristics, :retail_price, :wholesale_price, :retail_price_with_discount, :wholesale_price_with_discount, :rate, :bestseller, :novelty, :status, :buy_with, :wholesale_discount, :retail_discount, :pack, :weight, :clients_favorites, :image)
    end
end
