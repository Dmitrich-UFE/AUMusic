class AddVisibilityAndUserToPlaylists < ActiveRecord::Migration[8.1]
  def change
    add_column :playlists, :visibility, :string, default: "private", null: false
    #add_reference :playlists, :user, null: false, foreign_key: true
  end
end
