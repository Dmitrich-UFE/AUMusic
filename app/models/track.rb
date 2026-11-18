class Track < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :album, optional: true

  # Связь «многие ко многим» с соавторами
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  # ==========================================
  # СВЯЗИ ACTIVE STORAGE ДЛЯ ФАЙЛОВ
  # ==========================================
  has_one_attached :cover # Один файл обложки
  has_one_attached :audio # Один аудиофайл

  enum :visibility, { public: "public", private: "private" }, prefix: true, default: "private"

  scope :visible_for, ->(current_user) {
    if current_user
      where(visibility: "public").or(where(visibility: "private", user_id: current_user.id))
    else
      where(visibility: "public")
    end
  }

  # Метод точечной проверки прав доступа к конкретному треку по ID
  def accessible_by?(current_user)
    visibility_public? || (current_user.present? && user_id == current_user.id)
  end

  def likes_count
    reactions.where(kind: 'like').count
  end

  def dislikes_count
    reactions.where(kind: 'dislike').count
  end
  
  # Базовые валидации на уровне сервера (на случай обхода JS)
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 150 }
  validates :cover, presence: true
  validates :audio, presence: true



  before_create :generate_public_uid

  private

  def generate_public_uid
    loop do
      self.public_uid = rand(10000..999999999)
      break unless self.class.exists?(public_uid: public_uid)
    end
  end

end
