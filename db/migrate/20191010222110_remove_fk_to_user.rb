class RemoveFkToUser < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :users, :rooms
  end
end
