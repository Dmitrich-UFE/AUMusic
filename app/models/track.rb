class Track < ApplicationRecord
  # Трек может не принадлежать альбому (если это сингл)
  belongs_to :album, optional: true

  # Связь «многие ко многим» с артистами (авторами)
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
