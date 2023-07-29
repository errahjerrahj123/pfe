class AddForeignKeyToGuardians < ActiveRecord::Migration[7.0]
  def change
    add_column :guardians, :student_id, :integer
    add_foreign_key :guardians, :students
  end
end
