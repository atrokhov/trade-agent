class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel]

  # GET /orders
  def index
    if current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      @orders = Order.where(provider_id: manager.provider_id)
    elsif current_user.provider?
      provider = Provider.where(user: current_user).first
      @orders = Order.where(provider_id: provider)
    elsif current_user.client?
      client = Client.where(user: current_user).first
      @orders = Order.where(client: client)
    elsif current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      @orders = []
      waybills = Waybill.where(deliveryman: deliveryman)
      waybills.each do |waybill|
        waybill.invoice.each do |invoice|
          @orders += Order.where(invoice_id: invoice.id)
        end
      end
    elsif current_user.admin?
      @orders = Order.all
    end

    correct_json = []

    @orders.each do |order|
      correct_json.push(success_json(order))
    end

    render json: correct_json
  end

  # GET /orders/1
  def show
    if current_user.courier?
      deliveryman = Staff.where(user_id: current_user, role: "Курьер").first
      waybills = Waybill.where(deliveryman: deliveryman)
      waybills.each do |waybill|
        waybill.invoice.each do |invoice|
          invoice.order.each do |order|
            if order.id == @order.id
              render json: success_json(@order)
            end
          end
        end
      end
    elsif current_user.client?
      client = Client.where(user_id: current_user).first
      if @order.client == client
        render json: success_json(@order)
      end
    elsif current_user.manager?
      manager = Staff.where(user_id: current_user, role: "Менеджер").first
      if @order.provider == manager.provider
        render json: success_json(@order)
      end
    elsif current_user.provider?
      provider = Provider.where(user_id: current_user).first
      if @order.provider == provider
        render json: success_json(@order)
      end
    elsif current_user.admin?
      render json: success_json(@order)
    end
  end

  # GET /orders/new
  def new
    if current_user.client?
      client = Client.where(user: current_user).first
      @shops = Shop.where(client: client)
      @json = {shops: @shops}
    elsif current_user.admin?
      clients = []
      Client.all.each do |client|
        shops = Shop.where(client: client)
        client_json = {
                        id: client.id,
                        user: client.user,
                        date_of_birth: client.date_of_birth,
                        shops: shops
                      }
        clients.push(client_json)
        @json = {clients: clients}
      end
    elsif current_user.trade_agent?
      trade_agent = Staff.where(user_id: current_user.id).first
      district = District.find(trade_agent.district_id)

      clients = []
      
      district.clients.each do |client_id|
        shops = Shop.where(client_id: client_id)
        client = Client.find(client_id)
        client_json = {
                        id: client.id,
                        user: client.user,
                        date_of_birth: client.date_of_birth,
                        shops: shops
                      }
        clients.push(client_json)
      end
      @json = {clients: clients}
    end
      
    render json: @json
  end

  # POST /orders
  def create
    if current_user.client? or current_user.trade_agent?
      @order = Order.new(order_params)

      if current_user.client?
        @client = Client.where(user: current_user).first
      elsif current_user.trade_agent?
        @client = order_params[:client_id]
      end

      @order.client_id = @client.id
      
      if @order.product.nil? == false
        @order.provider_id = @order.product.provider_id
        if @order.save
          @order.dont_framed!
          if @client.private_person?
            @order.total = @order.product.retail_price_with_discount * @order.count
          elsif @client.store_point?
            @order.total = @order.product.wholesale_price_with_discount * @order.count
          end
          @order.save!
          render json: success_json(@order), status: :created, location: @order
        end
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  end

  def edit
    if current_user.client?
      client = Client.where(user: current_user).first
      @shops = Shop.where(client: client)
      @json = {order: success_json(@order), shops: @shops}
    elsif current_user.admin?
      clients = Client.all
      correct_json_for_clients = []
      clients.each do |client|
        shops = Shop.where(client: client)
        correct_json_for_clients.push({id: client.id, user: client.user, date_of_birth: client.date_of_birth}, shops: shops)
      end
      @json = {order: success_json(@order), clients: correct_json_for_clients}
    elsif current_user.trade_agent?
      trade_agent = Staff.where(user_id: current_user.id).first
      district = District.find(trade_agent.district_id)

      clients = []
      
      district.clients.each do |client_id|
        shops = Shop.where(client_id: client_id)
        client = Client.find(client_id)
        client_json = {
                        id: client.id,
                        user: client.user,
                        date_of_birth: client.date_of_birth,
                        shops: shops
                      }
        clients.push(client_json)
      end
      @json = {order: success_json(@order), clients: clients}
    end
      
    render json: @json
  end

  # PATCH/PUT /orders/1
  def update
    if current_user.client?
      client = Client.where(user: current_user).first
      if @order.client_id = client.id
        if @order.dont_framed!
          @order.update(order_params)
        end
      end
    end

    render json: success_json(@order)
  end

  # DELETE /orders/1
  def destroy
    client = Client.where(user: current_user).first
    if @order.client_id = client.id
      if @order.dont_framed?
        @order.destroy
      end
    end
  end

  def cancel
    client = Client.where(user: current_user).first
    if @order.client_id = client.id
      if @order.dont_framed?
        @order.status = "Отменен"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def success_json(order)
      provider = Provider.find(order.provider_id)
      shop = Shop.find(order.shop_id)

      return {
        id: order.id,
        product: order.product,
        client: {
          id: order.client.id,
          user: order.client.user,
          date_of_birth: order.client.date_of_birth
        },
        provider: {
          id: provider.id,
          name: provider.name, 
          address: provider.address, 
          phone: provider.phone, 
          description: provider.description, 
          status: provider.status,
          category: provider.category,
          user: provider.user
        },
        wishes: order.wishes,
        arrival_at: order.arrival_at,
        status: order.status,
        count: order.count,
        total: order.total,
        shop: shop,
        created_at: order.created_at, 
        updated_at: order.updated_at
      }
    end

    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:product_id, :client_id, :provider_id, :wishes, :arrival_at, :status, :total, :count, :invoice_id, :shop_id, :payment_type, :used_bonus, :tonnage, :accept_by_client, :accept_by_provider, :canceled_by_client, :canceled_by_provider)
    end
end
