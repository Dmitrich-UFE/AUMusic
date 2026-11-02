class CreateAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :albums do |t|
      t.string :title
      t.date :release_date
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
