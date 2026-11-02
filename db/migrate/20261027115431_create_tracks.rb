class CreateTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :duration
      t.references :artist, null: false, foreign_key: true
      t.string :album

      t.timestamps
    end
  end
end
