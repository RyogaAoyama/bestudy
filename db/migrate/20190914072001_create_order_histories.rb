class CreateOrderHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :order_histories do |t|
      t.references :room, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :is_order_success, default: false
      t.references :product, null: false

      t.timestamps
    end
  end
end
