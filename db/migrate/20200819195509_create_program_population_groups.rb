class CreateProgramPopulationGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :program_population_groups do |t|

      t.belongs_to :org, index: true
      t.belongs_to :program, index: true
      t.belongs_to :population_group, index: true

      t.timestamps
    end
  end
end
