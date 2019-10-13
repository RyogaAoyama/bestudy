class Admin::ProductRequestsController < ApplicationController
  def index
    user_ids = User.where(room_id: owner_room).pluck(:id)
    product_ids = ProductRequest.where(user_id: user_ids).pluck(:product_id)
    @products = Product.where(id: product_ids)
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "「#{ @product.name }」を承諾しました"
      
      # お知らせ
      Notice.new(
        user_id: ProductRequest.find_by(product_id: params[:id]).user_id,
        room_id: owner_room.id,
        type: 2
      ).save
      
      ProductRequest.find_by(product_id: params[:id]).destroy
      redirect_to admin_product_requests_url
    else
      render :edit
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy
      flash[:alert] = "「#{ product.name }」のリクエストを拒否しました"
      redirect_to admin_product_requests_url
    else
      flash[:alert] = "削除に失敗しました。再度時間を置いてお試しください"
      render :index
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
