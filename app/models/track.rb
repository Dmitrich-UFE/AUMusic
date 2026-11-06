class Track < ApplicationRecord
  belongs_to :album, optional: true

  # Связь «многие ко многим» с соавторами
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # ==========================================
  # СВЯЗИ ACTIVE STORAGE ДЛЯ ФАЙЛОВ
  # ==========================================
  has_one_attached :cover # Один файл обложки
  has_one_attached :audio # Один аудиофайл
  
  # Базовые валидации на уровне сервера (на случай обхода JS)
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 150 }
  validates :cover, presence: true
  validates :audio, presence: true
end
