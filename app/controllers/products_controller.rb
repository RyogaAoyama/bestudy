class ProductsController < ApplicationController
  before_action :no_correct_access
  def index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.half_size_change
    if @product.save
      redirect_to products_url
      flash[:notice] = "「#{ @product.name }」を登録しました"
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(
      :name,
      :point,
      :product_img
    )
  end
end
