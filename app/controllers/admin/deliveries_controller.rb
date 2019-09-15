class Admin::DeliveriesController < ApplicationController
  def index
    @deliveries = owner_room.delivery
  end

  def show
    @delivery = Delivery.find(params[:id])
  end

  # def new
  #   # TODO: テストデータ作成用
  #   product = Product.all.last
  #   order_history = OrderHistory.new(room_id: owner_room.id, user_id: 2, product_id: product.id)
  #   order_history.save!
  #   Delivery.new(product_id: product.id, room_id: owner_room.id, user_id: 2, order_history_id: order_history.id).save!
  #   redirect_to admin_deliveries_url
  # end

  def destroy
    delivery = Delivery.find(params[:id])
    order_history = delivery.order_history
    order_history.update!(is_order_success: true)
    delivery.destroy!
    flash[:notice] = '受け渡しが完了しました'
    redirect_to admin_deliveries_path
  end
end
