class GoodsController < ApplicationController
  after_action :clear_flash, only: [:destroy, :create]
  def index
    good_product_ids = current_user.goods.pluck(:product_id)
    @products = Product.where(id: good_product_ids)
    @point = current_point
  end

  def create
    good = Good.new(good_params)
    if good.save
      flash[:notice] = "#{ Product.find(good.product_id).name }をお気に入りに追加しました。"
    end
  end

  def destroy
    good = Good.find_by(good_params)
    if good.destroy
      flash[:alert] = "#{ Product.find(good.product_id).name }をお気に入りから削除しました。"
    end
  end

  private

  def good_params
    params.permit(:user_id, :product_id)
  end
end
