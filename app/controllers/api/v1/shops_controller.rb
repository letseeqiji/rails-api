class Api::V1::ShopsController < ApplicationController
  # before_action :set_per_page, only: [:index]
  # before_action :set_page, only: [:index]
  before_action :set_shop, only: [:show, :update, :destroy]
  before_action :check_login, only: [:create, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def index
    @shops  = Shop.page(current_page).per_page(per_page)
    option = get_links_serializer_options 'api_v1_shops_path', @shops
    render json: serializer_shop(@shops, 0, 'ok', option), status: 200
  end

  def show
    render json: serializer_shop(@shop), status: 200
  end

  def create
    @user = current_user
    @shop = Shop.new(shop_params)
    @shop.user = @user
    @shop.transaction do
      @user.role = 2
      if @shop.save! && @user.save!
        render json: serializer_shop(@shop), status: 201
      else
        render json: {error_code:500, message:@shop.errors}, status: 201
      end
    end
  end

  def update
    @user = current_user
    if @user.shop.update(shop_params)
      render json: serializer_shop(@shop), status: 201
    else
      render json: {error_code:500, message:@shop.errors}, status: 201
    end
  end

  def destroy
    @shop.destroy
    head 204
  end

  private
    def set_shop
      @shop = Shop.includes(:user).find_by_id params[:id]
      @shop = @shop || {} 
    end

    def shop_params
      params.require(:shop).permit(:name, :products_count, :orders_count)
    end

    def check_login
      head 401 unless current_user
    end

    def check_owner
      head 403 unless current_user.id == @shop.user.id
    end

    def serializer_shop(shop, error_code=0, message='ok', option = {})
      options = { include: [:user] }
      options = options.merge(option)
      shop_hash =  ShopSerializer.new(shop, options).serializable_hash
      shop_hash['error_code'] = error_code
      shop_hash['message'] = message
      return shop_hash
    end

    # def set_response_data shop
    #   retrun {} unless shop.present?
    #   {
    #     id: shop.id, 
    #     name: shop.name, 
    #     products_count: shop.products_count, 
    #     orders_count: shop.orders_count, 
    #     created_at: shop.created_at, 
    #     owner:{
    #        id: shop.user.id, 
    #        email: shop.user.email
    #     }
    #   }
    # end
end
