class RemoveArtistIdFromTracks < ActiveRecord::Migration[8.1]
  def change
    remove_reference :tracks, :artist, null: false, foreign_key: true
  end
end
