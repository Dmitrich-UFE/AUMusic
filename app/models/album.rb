class Album < ApplicationRecord
  # Связь «многие ко многим» с артистами (авторами)
  has_many :album_artists, dependent: :destroy
  has_many :artists, through: :album_artists

  # Внутри альбома может быть много треков
  has_many :tracks, dependent: :destroy
end
