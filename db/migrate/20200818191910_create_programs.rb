class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :quick_url
      t.string :contact_url
      t.string :program_url
      t.text :program_description_display
      t.text :population_description_display
      t.text :service_area_description_display
      t.boolean :inactive

      t.belongs_to :org, index: true

      t.timestamps
    end
  end
end
