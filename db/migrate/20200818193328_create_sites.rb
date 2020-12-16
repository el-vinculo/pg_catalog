class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :site_name
      t.string :name
      t.string :site_url
      t.string :site_ref
      t.boolean :admin
      t.boolean :delivery
      t.boolean :resource_dir
      t.boolean :inactive
      t.string :select_site_id

      t.belongs_to :org, index: true

      t.timestamps
    end
  end
end
