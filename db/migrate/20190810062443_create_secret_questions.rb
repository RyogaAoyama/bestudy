class CreateSecretQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :secret_questions do |t|
      t.string :question, null: false
      t.timestamps
    end
  end
end

