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
end
