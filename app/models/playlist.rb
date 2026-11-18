class Playlist < ApplicationRecord
  belongs_to :user

  enum :visibility, { public: "public", private: "private" }, prefix: true, default: "private"

  scope :visible_for, ->(current_user) {
    if current_user
      where(visibility: "public").or(where(visibility: "private", user_id: current_user.id))
    else
      where(visibility: "public")
    end
  }

  def accessible_by?(current_user)
    visibility_public? || (current_user.present? && user_id == current_user.id)
  end

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
