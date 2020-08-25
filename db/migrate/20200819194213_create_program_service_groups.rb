class CreateProgramServiceGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :program_service_groups do |t|

      t.belongs_to :org, index: true
      t.references :program, foreign_key: true
      t.references :service_group, foreign_key: true

      t.timestamps
    end
  end
end
