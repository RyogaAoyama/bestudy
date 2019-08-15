class RenameToGroups < ActiveRecord::Migration[5.2]
  def change
    rename_table :groups, :rooms
  end
end
