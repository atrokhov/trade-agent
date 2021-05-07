class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :update, :edit, :destroy, :block]

  # GET /staffs
  def index
    if current_user.provider?
      provider = Provider.where(user: current_user).first
      @staffs = Staff.where(provider_id: provider)
    elsif current_user.admin? or current_user.moderator?
      @staffs = Staff.all
    end

    correct_staffs = []

    @staffs.each do |staff|
      correct_staffs.push(correct_json(staff))
    end

    render json: {all_staff: correct_staffs}
  end

  def new
    if current_user.admin?
      providers = Provider.all
      users = User.where(role: nil)
      @staff = {providers: providers, users: users, roles: [:manager, :courier, :trade_agent]}
    elsif current_user.provider?
      users = User.where(role: nil)
      @staff = {users: users, roles: [:manager, :courier, :trade_agent]}
    elsif current_user.role == nil
      providers = Provider.all
      @staff = {providers: providers, roles: [:manager, :courier, :trade_agent]}
    end

    render json: @staff
  end

  def edit
    if current_user.admin?
      providers = Provider.all
      users = User.where(role: nil)
      @json = {providers: providers, users: users, roles: [:manager, :courier, :trade_agent], staff: correct_json(@staff)}
    elsif current_user.provider?
      users = User.where(role: nil)
      @json = {users: users, roles: [:manager, :courier, :trade_agent], staff: correct_json(@staff)}
    elsif current_user.role == nil
      providers = Provider.all
      @json = {providers: providers, roles: [:manager, :courier, :trade_agent], staff: correct_json(@staff)}
    end

    render json: @json
  end

  # GET /staffs/1
  def show
    render json: correct_json(@staff)
  end

  # POST /staffs
  def create
    if current_user.role == nil
      @staff = Staff.new(staff_params)
      @staff.user = current_user
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      @staff = Staff.new(staff_params)
      @staff.provider = provider
    elsif current_user.admin?
      @staff = Staff.new(staff_params)
    end

    if @staff.save
      render json: correct_json(@staff), status: :created, location: @staff
    else
      render json: @staff.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /staffs/1
  def update
    if @staff.update(staff_params)
      render json: correct_json(@staff)
    else
      render json: @staff.errors, status: :unprocessable_entity
    end
  end

  # DELETE /staffs/1
  def destroy
    @staff.destroy
  end

  def block
    if current_user.admin?
      user = User.find(@staff.user_id)
      user.blocked = true
      user.save!
    elsif current_user.provider? and @staff.provider == Provider.where(user: current_user)
      user = User.find(@staff.user_id)
      user.blocked = true
      user.save!
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    def correct_json(staff)
      if staff.avatar.attached?
        avatar = url_for(staff.avatar)
      else
        avatar = nil
      end

      if staff.district_id != nil
        district = District.find(staff.district_id)
      else
        district = nil
      end

      return {
        id: staff.id,
        avatar: avatar,
        user: staff.user,
        provider: {
          id: staff.provider.id, 
          name: staff.provider.name, 
          address: staff.provider.address, 
          phone: staff.provider.phone, 
          description: staff.provider.description, 
          status: staff.provider.status, 
          category: staff.provider.category, 
          user: staff.provider.user
        },
        role: staff.role,
        district: district,
        created_at: staff.created_at,
        updated_at: staff.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def staff_params
      params.require(:staff).permit(:role, :provider_id, :user_id, :district_id, :avatar)
    end
end
