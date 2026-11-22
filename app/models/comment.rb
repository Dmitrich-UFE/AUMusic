class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :track
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, -> { order(created_at: :asc) }, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  # Поддержка только одного уровня вложенности: если отвечают на ответ, привязываем к корневому родителю
  before_validation :enforce_single_nesting_level

  validates :body, presence: true, length: { maximum: 5000 }

  def likes_count
    comment_likes.size
  end

  def liked_by?(current_user)
    return false unless current_user
    comment_likes.any? { |cl| cl.user_id == current_user.id }
  end

  # Формула важности: ln(likes + 1) * ln(length) + 1
  def importance_score
    len = [body.to_s.length, 1].max
    Math.log(likes_count + 1) * Math.log(len) + 1.0
  end

  # Форматирование времени относительно текущего момента
  def formatted_time
    diff = Time.current - created_at
    if diff < 60
      "только что"
    elsif diff < 3600
      "#{(diff / 60).floor} мин. назад"
    elsif diff < 86_400
      "#{(diff / 3600).floor} ч. назад"
    elsif diff < 14 * 86_400
      "#{(diff / 86_400).floor} дн. назад"
    elsif created_at.year == Time.current.year
      created_at.strftime("%d/%m")
    else
      created_at.strftime("%d/%m/%Y")
    end
  end

  private

  def enforce_single_nesting_level
    if parent.present? && parent.parent_id.present?
      self.parent_id = parent.parent_id
    end
  end
end
