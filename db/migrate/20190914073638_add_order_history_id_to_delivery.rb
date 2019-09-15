class AddOrderHistoryIdToDelivery < ActiveRecord::Migration[5.2]
  def change
    add_reference :deliveries, :order_history
  end
end
