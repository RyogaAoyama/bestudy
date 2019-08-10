class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :regist_id
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
