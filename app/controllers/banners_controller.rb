class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :update, :destroy, :edit]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /banners
  def index
    @banners = []
    Banner.all.each do |banner|
      @banners.push(correct_json(banner))
    end

    render json: @banners
  end

  # GET /banners/1
  def show
    render json: correct_json(@banner)
  end

  def edit
    render json: correct_json(@banner)
  end

  # POST /banners
  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      render json: correct_json(@banner), status: :created, location: @banner
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /banners/1
  def update
    if @banner.update(banner_params)
      render json: correct_json(@banner)
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  # DELETE /banners/1
  def destroy
    @banner.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    def correct_json(banner)
      if banner.image.attached?
        image = url_for(banner.image)
      else
        image = nil
      end

      return {
        id: banner.id,
        image: image,
        name: banner.name,
        link: banner.link,
        created_at: banner.created_at,
        updated_at: banner.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def banner_params
      params.require(:banner).permit(:name, :link, :image)
    end
end
