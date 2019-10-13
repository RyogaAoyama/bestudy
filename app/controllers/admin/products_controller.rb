class Admin::ProductsController < ApplicationController
  def index
    p session[:id]
    p current_user
    p owner_room
    @products = owner_room.product.where(is_deleted: false)
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = owner_room.product.new(product_params)

    # @product.pointは代入した瞬間にInteger型に自動変換されるため引数にparamsを使用
    @product.point = @product.half_size_change(product_params[:point])
    @product.user_id = current_user.id

    if @product.valid?
      @product.default_image_set
      @product.save
      flash[:notice] = "「#{ @product.name }」を登録しました"
      redirect_to admin_products_url
    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "「#{ @product.name }」を更新しました"
      redirect_to admin_products_url
    else
      render :edit
    end
  end

  def destroy_modal
    @product = Product.find(params[:id])
  end

  def set_deleted
    @product = Product.find(params[:id])
    if @product.update(is_deleted: true)
      flash[:alert] = "「#{ @product.name }」を削除しました"
      redirect_to admin_products_url
    else
      flash[:alert] = '削除に失敗しました。再度時間を置いてお試しください。'
      render :edit
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
