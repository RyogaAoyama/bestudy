class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :login_id, null: false, unique: true
      t.string :answer, null: false
      t.string :password, null: false, unique: true
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
