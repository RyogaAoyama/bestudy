class Admin::ProductRequestsController < ApplicationController
  def index
    user_ids = User.where(room_id: owner_room).pluck(:id)
    product_ids = ProductRequest.where(user_id: user_ids).pluck(:product_id)
    @products = Product.where(id: product_ids)
  end

  def new
    #TODO: これはリクエストのテスト用だからいらなくなったら消す
    file = File.open("public/test.jpg")
    product = Product.new(name:"リクエスト", point: 200, room_id: 1, user_id: 2)
    product.product_img.attach(io: file, filename: "test.jpg")
    product.save!
    ProductRequest.new(user_id:2, product_id:product.id).save!
    redirect_to admin_product_requests_url
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "「#{ @product.name }」を承諾しました"
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
