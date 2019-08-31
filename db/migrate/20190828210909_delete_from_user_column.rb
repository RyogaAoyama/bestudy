class DeleteFromUserColumn < ActiveRecord::Migration[5.2]
  def up
    remove_column :rooms, :users_id
  end

  def down
    add_references :rooms, :users, foreign_key: true
  end
end
