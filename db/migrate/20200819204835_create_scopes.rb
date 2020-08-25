class CreateScopes < ActiveRecord::Migration[5.2]
  def change
    create_table :scopes do |t|
      t.string :geo_scope
      t.string :neigborhood
      t.string :city
      t.string :county
      t.string :state
      t.string :region
      t.string :country
      t.boolean :inactive
      t.integer :program_id

      t.belongs_to :org, index: true

      t.timestamps
    end
  end
end
