class CreateServiceGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :service_groups do |t|
      t.string :name
      t.string :vocabulary
      t.boolean :inactive
      t.integer :call_total

      t.timestamps
    end
  end
end
