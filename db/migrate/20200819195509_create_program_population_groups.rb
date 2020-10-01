class CreateProgramPopulationGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :program_population_groups do |t|

      t.belongs_to :org, index: true
      t.references :program, foreign_key: true
      t.references :population_group, foreign_key: true

      t.timestamps
    end
  end
end
