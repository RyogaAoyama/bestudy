class AddReferencesToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :groups, foreign_key: true
    add_reference :users, :secret_question, foreign_key: true
    add_reference :groups, :users, foreign_key: true
  end
end
