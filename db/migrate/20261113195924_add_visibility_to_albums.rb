class AddVisibilityToAlbums < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :visibility, :string, default: "private", null: false
  end
end
