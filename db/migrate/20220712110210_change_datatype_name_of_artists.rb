class ChangeDatatypeNameOfArtists < ActiveRecord::Migration[6.1]
  def change
    change_column :artists, :name, :string
  end
end
