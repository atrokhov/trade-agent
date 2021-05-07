class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /blogs
  def index
    @blogs = []

    Blog.all.each do |blog|
      @blogs.push(correct_json(blog))
    end

    render json: @blogs
  end

  # GET /blogs/1
  def show
    render json: correct_json(@blog)
  end

  # POST /blogs
  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render json: correct_json(@blog), status: :created, location: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/1
  def update
    if @blog.update(blog_params)
      render json: correct_json(@blog)
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /blogs/1
  def destroy
    @blog.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def correct_json(blog)
      if blog.image.attached?
        image = url_for(blog.image)
      else
        image = nil
      end

      return {
        id: blog.id,
        image: image,
        name: blog.name,
        body: blog.body,
        created_at: blog.created_at,
        updated_at: blog.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def blog_params
      params.require(:blog).permit(:name, :body, :image)
    end
end
