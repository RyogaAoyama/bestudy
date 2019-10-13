class Admin::DeliveriesController < ApplicationController
  def index
    @deliveries = owner_room.delivery
  end

  def show
    @delivery = Delivery.find(params[:id])
  end

  def destroy
    delivery = Delivery.find(params[:id])
    order_history = delivery.order_history
    order_history.update!(is_order_success: true)
    delivery.destroy!
    flash[:notice] = '受け渡しが完了しました'
    redirect_to admin_deliveries_path
  end
end
