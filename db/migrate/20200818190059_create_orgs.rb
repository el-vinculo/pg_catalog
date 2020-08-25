class CreateOrgs < ActiveRecord::Migration[5.2]
  def change
    create_table :orgs do |t|
      t.string :domain
      t.string :name
      t.text :description_display
      t.string :org_type
      t.string :home_url
      t.boolean :inactive
      t.boolean :referral

      t.timestamps
    end
  end
end
