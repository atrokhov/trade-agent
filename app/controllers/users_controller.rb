class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :block, :edit, :update]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def edit
    render json: @user
  end

  def update
    if (user_params[:password].blank? && @user.update_without_password(user_params)) || @user.update(user_params)
      sign_in(@user, bypass: true)

      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def block
    @user.blocked = true
    @user.save!

    render json: @user
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :name, :phone, :email, :role, :blocked, :password, :password_confirmation)
    end
end
