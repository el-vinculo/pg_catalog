class CreateProgramServiceTags < ActiveRecord::Migration[5.2]
  def change
    create_table :program_service_tags do |t|

      t.belongs_to :org, index: true
      t.belongs_to :program, index: true
      t.belongs_to :service_tag, index: true

      t.timestamps
    end
  end
end
