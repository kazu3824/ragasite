class Track < ApplicationRecord
  belongs_to :user
  belongs_to :artist
  belongs_to :tag
  has_many :track_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :line_items, dependent: :destroy

  validates :title, presence: true

  def favorited_by?(user)
    track_favorites.exists?(user_id: user.id)
  end

  def artist_name
    # artistがnilの場合は、nameというメソッドを実行せず、nilを返す。& => Rubyの構文。ぼっち演算子
    artist&.name
  end
end
