class CreatePointNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :point_notices do |t|
      t.integer :get_point
      t.integer :type
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.references :special_point

      t.timestamps
    end
  end
end
