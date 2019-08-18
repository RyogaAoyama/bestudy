class RenameColumnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :groups_id, :rooms_id
  end
end
