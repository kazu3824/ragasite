class AddTracksToTagId < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :tag_id, :integer
  end
end
