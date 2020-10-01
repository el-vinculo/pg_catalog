class CreateProgramServiceTags < ActiveRecord::Migration[5.2]
  def change
    create_table :program_service_tags do |t|

      t.belongs_to :org, index: true
      t.references :program, foreign_key: true
      t.references :service_tag, foreign_key: true

      t.timestamps
    end
  end
end
