class CreateFavoriteQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_queries do |t|

      t.string :query_name
      t.string :owner
      t.integer :query_count
      t.boolean :global
      t.json :search_query, default: {}
      t.timestamps

    end
  end
end
