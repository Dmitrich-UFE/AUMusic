class TrackArtist < ApplicationRecord
  belongs_to :track
  belongs_to :artist
end
