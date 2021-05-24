class Api::V1::ProductsController < ApplicationController
  before_action :check_owner, only: [:update, :destroy]
  before_action :set_product, only: [:edit, :update, :show, :destroy]
  
  def index
    @products  = Product.page(current_page).per_page(per_page)
    option = get_links_serializer_options 'api_v1_products_path', @products
    render json: serializer_product(@products, 0, 'ok', option), status: 200
  end

  def show
    render json: serializer_product(@product), status:200
  end

  def create
    @product = current_user&.shop&.products&.build(product_params)

    # byebug
    if @product.save
      render json: serializer_product(@product), status: 201
    else
      render json: {error_code:500, message:@product.errors}, status: 201
    end
  end

  def update
    if @product.update(product_params)
      render json: serializer_product(@product), status: 202
    else
      render json: {error_code:500, message:@product.errors}, status: 202
    end
  end

  def destroy
    @product.destroy
    head 204
  end

  private
    def serializer_product(product, error_code=0, message='ok', option = {})
      product_hash =  ProductSerializer.new(product, option).serializable_hash
      product_hash['error_code'] = error_code
      product_hash['message'] = message
      return product_hash
    end

    def set_product
      @product = Product.find_by_id params[:id].to_i
      @product = @product || {} 
    end

    def product_params
      params.require(:product).permit(:title, :price, :published)
    end

    def check_owner
      head 403 unless current_user&.shop&.products&.exists?(id:params[:id].to_i)
    end
end
