class CreateGrabLists < ActiveRecord::Migration[5.2]
  def change
    create_table :grab_lists do |t|
      t.string :field_name
      t.text :text
      t.string :xpath
      t.string :page_url
      t.boolean :inactive
      t.integer :program_id
      t.integer :site_id
      t.integer :poc_id

      t.belongs_to :org, index: true


      t.timestamps
    end
  end
end
