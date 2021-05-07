class WaybillsController < ApplicationController
  before_action :set_waybill, only: [:show, :edit, :update, :destroy]

  # GET /waybills
  def index
    if current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      @waybills = Waybill.where(manager: manager)
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      @waybills = Waybill.where(provider_id: provider)
    elsif current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      @waybills = Waybill.where(deliveryman: deliveryman)
    elsif current_user.admin?
      @waybills = Waybill.all
    end

    correct_waybills = []
    @waybills.each do |waybill|
      correct_waybills.push(correct_json(waybill))
    end

    render json: correct_waybills
  end

  # GET /waybills/1
  def show
    if current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      if @waybill.deliveryman == deliveryman
        render json: {waybill: correct_json(@waybill)}
      end
    elsif current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      if @waybill.manager == manager
        render json: {waybill: correct_json(@waybill)}
      end
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      if @waybill.provider == provider
        render json: {waybill: correct_json(@waybill)}
      end
    elsif current_user.admin?
      render json: {waybill: correct_json(@waybill)}
    end
  end

  # GET  /waybills/new
  def new
    if current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      deliverymen = Staff.where(provider: manager.provider, role: "Курьер")
      invoices = Invoice.where(provider: manager.provider, status: false, waybill_id: nil)
      correct_deliverymen = []
      correct_invoices = []

      deliverymen.each do |deliveryman|
        correct_deliverymen.push(correct_json_for_staff(deliveryman))
      end

      invoices.each do |invoice|
        correct_invoices.push(correct_json_for_invoice(invoice))
      end

      render json: {couriers: correct_deliverymen, invoices: correct_invoices}
    end
  end

  # POST /waybills
  def create
    @waybill = Waybill.new(waybill_params)

    manager = Staff.where(user_id: current_user, role: "Менеджер").first
    invoices = Invoice.where(provider_id: manager.provider_id, status: false)

    @waybill.manager_id = manager.id
    @waybill.provider_id = manager.provider_id
    
    loop do
      @waybill.number = (SecureRandom.random_number(9e5) + 1e5).to_i
      if Waybill.where(number: number).first != nil
        @waybill.number = (SecureRandom.random_number(9e5) + 1e5).to_i
      else
        break
      end
    end

    @waybill.save!
    
    @waybill.invoices.each do |invoice_id|
      invoice = Invoice.where(id: invoice_id).first
      invoice.waybill_id = @waybill.id
      invoice.save!
      target_client = User.where(id: invoice.client.user_id).first
      ActionCable.server.broadcast("notification_channel:#{target_client.id}", "#{target_client.name}! Ваш заказ оформлен!")
      invoice.order.each do |order|
        order.framed!
        order.save!
      end
    end

    target_courier = User.find(@waybill.deliveryman.user_id)
    ActionCable.server.broadcast("notification_channel:#{target_courier.id}", "#{target_courier.name}! Вам новый маршрутный лист!")

    render json: correct_json(@waybill)
  end

  def edit
    if current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      deliverymen = Staff.where(provider: manager.provider, role: "Курьер")
      invoices = Invoice.where(provider: manager.provider, status: false, waybill_id: nil)
      correct_deliverymen = []
      correct_invoices = []

      deliverymen.each do |deliveryman|
        correct_deliverymen.push(correct_json_for_staff(deliveryman))
      end

      invoices.each do |invoice|
        correct_invoices.push(correct_json_for_invoice(invoice))
      end

      render json: {couriers: correct_deliverymen, invoices: correct_invoices, waybill: correct_json(@waybill)}
    end
  end

  # PATCH/PUT /waybills/1
  def update
    counter = 0

    @waybill.invoice.each do |invoice|
      if invoice.status == true
        counter += 1
      end
    end

    if counter < 1
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      invoices = Invoice.where(provider_id: manager.provider_id, status: false)

      @waybill.manager_id = manager.id
      @waybill.provider_id = manager.provider_id

      if waybill_params[:deliveryman_id] != nil
        @waybill.deliveryman_id = waybill_params[:deliveryman_id]
      end

      if waybill_params[:invoices] != []
        @waybill.invoices = waybill_params[:invoices]
      end

      @waybill.save!
      
      @waybill.invoices.each do |invoice_id|
        invoice = Invoice.find(invoice_id)
        invoice.waybill_id = @waybill.id
        invoice.save!
        target_user = User.where(id: invoice.client.user_id).first
        ActionCable.server.broadcast("notification_channel:#{target_user.id}", "#{target_user.name}! Ваш заказ переоформлен!")
        invoice.order.each do |order|
          order.framed!
          order.save!
        end
      end
    end

    render json: correct_json(@waybill)
  end

  # DELETE /waybills/1
  def destroy
    @waybill.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waybill
      @waybill = Waybill.find(params[:id])
    end

    def correct_json_for_staff(staff)
      return {
        id: staff.id,
        user: staff.user,
        role: staff.role,
        provider: {
          name: staff.provider.name,
          address: staff.provider.address,
          phone: staff.provider.phone,
          description: staff.provider.description,
          status: staff.provider.status,
          category: staff.provider.category,
          user: staff.provider.user
        }
      }
    end

    def correct_json_for_invoice(invoice)
      shop = Shop.find(invoice.shop_id)
      return {
        id: invoice.id,
        client: {
          user: invoice.client.user,
          date_of_birth: invoice.client.date_of_birth
        },
        provider: {
          name: invoice.provider.name,
          address: invoice.provider.address,
          phone: invoice.provider.phone,
          description: invoice.provider.description,
          status: invoice.provider.status,
          category: invoice.provider.category,
          user: invoice.provider.user
        },
        shop: {
          name: shop.name,
          address: shop.address,
          city: shop.city,
          type: shop.type
        },
        status: invoice.status
      }
    end

    def correct_json(waybill)
      invoices = []
      waybill.invoice.each do |invoice|
        invoices.push(correct_json_for_invoice(invoice))
      end

      return {
        id: waybill.id,
        number: waybill.number,
        provider: {
          name: waybill.provider.name,
          address: waybill.provider.address,
          phone: waybill.provider.phone,
          description: waybill.provider.description,
          status: waybill.provider.status,
          category: waybill.provider.category,
          user: waybill.provider.user
        },
        manager: {
          user: waybill.manager.user
        },
        courier: {
          user: waybill.deliveryman.user
        },
        invoices: invoices,
        status: waybill.status,
        created_at: waybill.created_at,
        updated_at: waybill.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def waybill_params
      params.require(:waybill).permit(:status, :provider_id, :manager_id, :deliveryman_id, invoices: [])
    end
end
