class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show, :update, :edit, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /subcategories
  def index
    @subcategories = []
    Subcategory.all.each do |subcategory|
      @subcategories.push(correct_json(subcategory))
    end

    render json: @subcategories
  end

  # GET /subcategories/1
  def show
    render json: correct_json(@subcategory)
  end

  def new
    @categories = Category.all

    render json: {categories: @categories}
  end

  def edit
    @categories = Category.all

    render json: {categories: @categories, subcategory: correct_json(@subcategory)}
  end

  # POST /subcategories
  def create
    @subcategory = Subcategory.new(subcategory_params)

    if @subcategory.save
      render json: correct_json(@subcategory), status: :created, location: @subcategory
    else
      render json: @subcategory.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subcategories/1
  def update
    if @subcategory.update(subcategory_params)
      render json: correct_json(@subcategory)
    else
      render json: @subcategory.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subcategories/1
  def destroy
    @subcategory.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    def correct_json(subcategory)
      return {
        id: subcategory.id,
        category: subcategory.category,
        name: subcategory.name,
        description: subcategory.description,
        created_at: subcategory.created_at,
        updated_at: subcategory.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def subcategory_params
      params.require(:subcategory).permit(:name, :description, :category_id)
    end
end
