class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :curriculum
      t.references :user
      t.references :room
      t.integer :result

      t.timestamps
    end
  end
end
