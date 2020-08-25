class CreatePopulationTags < ActiveRecord::Migration[5.2]
  def change
    create_table :population_tags do |t|
      t.string :name
      t.boolean :inactive
      t.integer :call_total

      t.timestamps
    end
  end
end
