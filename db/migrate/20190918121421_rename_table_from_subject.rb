class RenameTableFromSubject < ActiveRecord::Migration[5.2]
  def change
    rename_table :subjects, :curriculums
  end
end
