class RemoveAddFromProductsToUserId < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :room, foreign_key: true
  end
end
