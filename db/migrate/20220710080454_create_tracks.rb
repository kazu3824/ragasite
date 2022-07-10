class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.integer :artist_id
      t.text :title
      t.text :description
      t.text :url
      t.timestamps
    end
  end
end
