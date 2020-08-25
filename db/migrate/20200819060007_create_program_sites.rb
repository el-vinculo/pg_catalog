class CreateProgramSites < ActiveRecord::Migration[5.2]
  def change
    create_table :program_sites do |t|
      t.references :program, foreign_key: true
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
