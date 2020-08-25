class CreateSitePocs < ActiveRecord::Migration[5.2]
  def change
    create_table :site_pocs do |t|
      t.references :site, foreign_key: true
      t.references :poc, foreign_key: true

      t.timestamps
    end
  end
end
