class AddSelectProgramIdToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :select_program_id, :string
  end
end
