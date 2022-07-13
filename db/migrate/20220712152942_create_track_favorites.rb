class CreateTrackFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :track_favorites do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end
  end
end
