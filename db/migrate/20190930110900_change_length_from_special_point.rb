class ChangeLengthFromSpecialPoint < ActiveRecord::Migration[5.2]
  def change
    change_column :special_points, :message, :text
  end
end
