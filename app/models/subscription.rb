class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: "User"
  belongs_to :author, class_name: "User"

  validates :subscriber_id, uniqueness: { scope: :author_id }
end
