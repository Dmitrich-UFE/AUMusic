class FixAlbumReferenceOnTracks < ActiveRecord::Migration[8.1]
  def change
    remove_column :tracks, :album, :string
    add_reference :tracks, :album, null: true, foreign_key: true
  end
end
