# 商品リクエストコントローラ
class ProductRequestsController < ApplicationController
  def index
    product_ids = ProductRequest.where(user_id: current_user.id).pluck(:product_id)
    @products = if product_ids.present?
                  Product.where(id: product_ids)
                else
                  ''
                end

    @point = Point.find_by(user_id: current_user)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.setup(current_user)

    @product.transaction do
      if @product.save!
        # リクエスト
        ProductRequest.new(user_id: current_user.id, product_id: @product.id).save!

        # お知らせ
        Notice.new(
          user_id: current_user.id,
          room_id: current_user.room_id,
          type: 5
        ).save!

        flash[:notice] = "「#{ @product.name }」をリクエストしました"
        redirect_to product_requests_path
      else
        render :new
      end
    end
  rescue StandardError
    render :new
    flash[:alert] = 'リクエストに失敗しました。再度時間をおいてお試しください。'
  end

  def destroy
    product_request = ProductRequest.find_by(product_id: params[:id])
    product = Product.find(product_request.product_id)

    flash[:alert] = "#{ product.name }のリクエストを取り消しました。"

    # 削除
    product.destroy

    redirect_to product_requests_url
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :product_img
    )
  end
end
