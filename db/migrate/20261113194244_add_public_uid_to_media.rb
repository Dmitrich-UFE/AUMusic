class AddPublicUidToMedia < ActiveRecord::Migration[8.1]
  def change
    add_column :tracks, :public_uid, :bigint
    add_index :tracks, :public_uid, unique: true

    add_column :albums, :public_uid, :bigint
    add_index :albums, :public_uid, unique: true

    add_column :playlists, :public_uid, :bigint
    add_index :playlists, :public_uid, unique: true
  end
end
