class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :point, null: false
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
