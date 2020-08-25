class CreateProgramPocs < ActiveRecord::Migration[5.2]
  def change
    create_table :program_pocs do |t|
      t.references :program, foreign_key: true
      t.references :poc, foreign_key: true

      t.timestamps
    end
  end
end
