class InstuctionsController < ApplicationController
  before_action :set_instuction, only: [:show, :update, :destroy]

  # GET /instuctions
  def index
    @instuctions = Instuction.all

    render json: @instuctions
  end

  # GET /instuctions/1
  def show
    render json: @instuction
  end

  # POST /instuctions
  def create
    @instuction = Instuction.new(instuction_params)

    if @instuction.save
      render json: @instuction, status: :created, location: @instuction
    else
      render json: @instuction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /instuctions/1
  def update
    if @instuction.update(instuction_params)
      render json: @instuction
    else
      render json: @instuction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /instuctions/1
  def destroy
    @instuction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instuction
      @instuction = Instuction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def instuction_params
      params.require(:instuction).permit(:name)
    end
end
