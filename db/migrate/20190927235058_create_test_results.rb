class CreateTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :test_results do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.references :curriculum, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
