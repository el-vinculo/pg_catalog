class CreatePocs < ActiveRecord::Migration[5.2]
  def change
    create_table :pocs do |t|
      t.string :poc_name
      t.string :title
      t.string :mobile
      t.string :work
      t.string :email
      t.boolean :inactive

      t.belongs_to :org, index: true

      t.timestamps
    end
  end
end
