class TrackFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :track
  
   validates_uniqueness_of :track_id, scope: :user_id
end
