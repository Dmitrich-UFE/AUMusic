class Artist < ApplicationRecord
  belongs_to :user

  # Связи с альбомами
  has_many :album_artists, dependent: :destroy
  has_many :albums, through: :album_artists

  # Связи с треками
  has_many :track_artists, dependent: :destroy
  has_many :tracks, through: :track_artists
end
