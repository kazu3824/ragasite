class Track < ApplicationRecord
  belongs_to :user
  belongs_to :artist
  belongs_to :tag
  has_many :track_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :artist

  def favorited_by?(user)
    track_favorites.exists?(user_id: user.id)
  end
end
