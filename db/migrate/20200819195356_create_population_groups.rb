class CreatePopulationGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :population_groups do |t|
      t.string :name
      t.boolean :inactive
      t.integer :call_total

      t.timestamps
    end
  end
end
