class CreateProductRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :product_requests do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.timestamps
    end
    rename_column :users, :rooms_id, :room_id
  end
end
