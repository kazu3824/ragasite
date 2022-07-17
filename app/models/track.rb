class Track < ApplicationRecord
  belongs_to :user
  belongs_to :artist
  belongs_to :tag
  has_many :track_favorites, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :artist

  def favorited_by?(user)
    track_favorites.exists?(user_id: user.id)
  end
end
