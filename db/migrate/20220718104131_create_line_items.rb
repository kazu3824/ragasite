class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.references :play_list, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
