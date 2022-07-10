class CreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :artists do |t|
      t.integer :name
      t.text :description

      t.timestamps
    end
  end
end
