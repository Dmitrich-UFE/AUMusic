class Album < ApplicationRecord
  # Связь «многие ко многим» с артистами (авторами)
  has_many :album_artists, dependent: :destroy
  has_many :artists, through: :album_artists

  # Внутри альбома может быть много треков
  has_many :tracks, dependent: :destroy

  has_one_attached :cover # Для Album и Playlist (у Track уже есть)
  before_create :generate_public_uid

  private

  def generate_public_uid
    loop do
      self.public_uid = rand(10000..999999999)
      break unless self.class.exists?(public_uid: public_uid)
    end
  end

end
