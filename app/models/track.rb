class Track < ApplicationRecord
  belongs_to :user
  belongs_to :artist
  belongs_to :tag
  has_many :track_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :line_items, dependent: :destroy

  validates :title, presence: true
  # なぜorder,sort_byのメソッドが使えるか？ApplicationRecordをTrackで使えるように一行目で定義されているから。
  # orderのcreated_atカラムdescを使って降順(新しい順)に並び替えている
  scope :latest, -> { order(created_at: :desc) }
  # orderのcreated_atカラムをascを使って昇順(古い順)に並び替えている
  scope :old, -> { order(created_at: :asc) }
  # sort_byでいいねの少ない順に並び替えてreverseでいいねの多い順に並び替えている。※sort_byはRubyの仕様で少ない順に並び替えられるため
  scope :order_by_favorite, -> { sort_by {|track| track.track_favorites.size }.reverse }

  def self.sort_by_condition(params)
    # URLのパラメーターにoldが存在している時
    if params[:old]
      old
    # order_by_favoriteが存在している時
    elsif params[:order_by_favorite]
      order_by_favorite
    # それ以外
    else
      latest
    end
  end

  def favorited_by?(user)
    track_favorites.exists?(user_id: user.id)
  end

  def artist_name
    # artistがnilの場合は、nameというメソッドを実行せず、nilを返す。& => Rubyの構文。ぼっち演算子
    artist&.name
  end
end
