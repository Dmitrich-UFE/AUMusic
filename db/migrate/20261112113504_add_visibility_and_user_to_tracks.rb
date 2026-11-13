class AddVisibilityAndUserToTracks < ActiveRecord::Migration[8.1]
  def change
    add_column :tracks, :visibility, :string, default: "private", null: false
    add_reference :tracks, :user, null: false, foreign_key: true
  end
end
