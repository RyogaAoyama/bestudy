class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.references :user
      t.integer :point
      t.integer :total
      t.references :room

      t.timestamps
    end
  end
end
