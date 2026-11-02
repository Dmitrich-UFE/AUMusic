class CreateArtists < ActiveRecord::Migration[8.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :bio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
