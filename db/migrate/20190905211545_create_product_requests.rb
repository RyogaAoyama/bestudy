class CreateProductRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :product_requests do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.timestamps
    end
  end
end
