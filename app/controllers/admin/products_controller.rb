class Admin::ProductsController < ApplicationController
  def index
    @products = current_user.product
  end

  def new
    #TODO: デフォルト画像挿入
    @product = Product.new
  end

  def create
    @product = current_user.product.new(product_params)

    # @product.pointは代入した瞬間にInteger型に自動変換されるため引数にparamsを使用
    @product.point = @product.half_size_change(product_params[:point])

    unless @product.product_img.attached?
      @product.default_image_set
    end
    if @product.save
      flash[:notice] = "「#{ @product.name }」を登録しました"
      redirect_to admin_products_url
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
