class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: [:index, :show, :create]
  before_action :set_order, only: [:show]
  
  def index
    @orders = current_user.orders.page(current_page).per_page(per_page)
    option = get_links_serializer_options 'api_v1_orders_path', @orders
    render json: serializer_order(@orders, 0, 'ok', option), status:200
  end

  def show
    option = {include: [:products]}
    render json: serializer_order(@order, 0, 'ok', option), status:200
  end

  def create
    @order = current_user.orders.create()
    @order.build_order_placement(order_params[:products])
    
    # byebug
    if @order.save
      render json: serializer_order(@order), status: 201
    else
      render json: {errors: @order.errors}, status: 500
    end
  end


  private
    def serializer_order(order, error_code=0, message='ok', option = {})
      order_hash =  OrderSerializer.new(order, option).serializable_hash
      order_hash['error_code'] = error_code
      order_hash['message'] = message
      return order_hash
    end

    def check_login
      head 403 unless current_user
    end

    def set_order
      @order = current_user.orders.find_by_id params[:id].to_i
      @order = @order || {} 
    end

    def order_params
      # 只保留允许的字段，屏蔽不允许的字段
      params.require(:order).permit(products:[:id, :quantity])
    end

    def set_price_total
      # order_params.map{|product| # 需要先找出对应的产品 }
    end
end
