class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy, :complete_invoice]

  # GET /invoices
  def index
    if current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      @invoices = Invoice.where(provider_id: manager.provider_id)
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      @invoices = Invoice.where(provider: provider)
    elsif current_user.client?
      client = Client.where(user: current_user).first
      @invoices = Invoice.where(client: client)
    elsif current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      waybills = Waybill.where(deliveryman: deliveryman)
      waybills.each do |waybill|
        @invoices = Invoice.where(client: client, waybill: waybill)
      end
    elsif current_user.admin? or current_user.moderator?
      @invoices = Invoice.all
    end

    correct_invoices = []

    @invoices.each do |invoice|
      correct_invoices.push(correct_json(invoice))
    end

    render json: correct_invoices
  end

  # GET /invoices/1
  def show
    if current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      waybills = Waybill.where(deliveryman: deliveryman)
      waybills.each do |waybill|
        waybill.invoice.each do |invoice|
          if invoice.id == @invoice.id
            render json: {invoice: correct_json(@invoice)}
          end
        end
      end
    elsif current_user.client?
      client = Client.where(user_id: current_user).first
      if @invoice.client == client
        render json: {invoice: correct_json(@invoice)}
      end
    elsif current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      if @invoice.provider == manager.provider
        render json: {invoice: correct_json(@invoice)}
      end
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      if @invoice.provider == provider
        render json: {invoice: correct_json(@invoice)}
      end
    elsif current_user.admin?
      render json: correct_json(@invoice)
    end
  end

  # POST /invoices
  def create
    if current_user.client?
      client = Client.where(user: current_user).first
      orders = Order.where(client: client, status: "Не оформлен")

      providers = []
      addresses = []

      orders.each do |order|
        providers.push(order.provider_id)
      end

      providers.uniq!

      addresses_to_providers = []

      providers.each do |provider|
        orders_to_provider = orders.where(provider_id: provider)
        orders_to_provider.each do |order|
          addresses.push(order.shop_id)
        end
        addresses.uniq!
        addresses_to_providers.push({provider: provider, addresses: addresses})
        addresses = []
      end

      addresses_to_providers.each do |addresses_to_provider_id|
        addresses_to_provider_id[:addresses].each do |address|
          @invoice = Invoice.new(invoice_params)
          @invoice.client = client
          @invoice.status = false
          @invoice.provider = Provider.where(id: addresses_to_provider_id[:provider]).first
          @invoice.shop_id = address

          @invoice.save!
          managers = Staff.where(provider_id: addresses_to_provider_id[:provider], role: "Менеджер")

          managers.each do |manager|
            target_user = User.where(id: manager.user_id).first
            ActionCable.server.broadcast("notification_channel:#{target_user.id}", "#{target_user.name}! У компании новые заказы!")
          end

          orders_address = orders.where(shop_id: address)
          orders_to_provider = orders_address.where(provider_id: addresses_to_provider_id[:provider])
          orders_to_provider.each do |order|
            order.invoice_id = @invoice.id
            order.processing!
            order.product.save!
            order.save!
          end
        end
      end
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /complete_invoice/1
  def complete_invoice
    client = Client.where(user: current_user).first
    waybill = Waybill.find(@invoice.waybill_id)
    counter = 0

    if client != nil and @invoice.client == client
      @invoice.status = true
      @invoice.save!
      invoices = Invoice.where(waybill_id: waybill.id)
      invoices.each do |invoice|
        if invoice.status == true
          counter += 1
        end

        @invoice.order.each do |order|
          order.delivered!
          order.save!
        end
      end

      if counter == waybill.invoice.count
        waybill.status = true
        waybill.save!
      end
    end
      
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def correct_json(invoice)
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
        orders: invoice.order,
        status: invoice.status,
        created_at: invoice.created_at,
        updated_at: invoice.updated_at
      }
    end

    # Only allow a trusted parameter "white list" through.
    def invoice_params
      params.permit(:client_id, :shop_id, :status, :provider_id, :waybill_id)
    end
end
