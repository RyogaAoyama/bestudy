class CreateSpecialPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :special_points do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.string :message
      t.integer :point

      t.timestamps
    end
  end
end
