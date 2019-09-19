class CreateCurriculums < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculums do |t|
      t.string :name, null: false
      t.boolean :is_deleted, default: false
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
