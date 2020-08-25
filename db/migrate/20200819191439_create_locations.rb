class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :addr1
      t.string :addr2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.boolean :primary_poc
      t.boolean :inactive

      t.references :sites, foreign_key: true

      t.timestamps
    end
  end
end
