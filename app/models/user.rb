class User < ApplicationRecord
  GUEST_EMAIL = "guest@example.com"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :tracks, dependent: :destroy
  has_many :track_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :track_favorited_tracks, through: :track_favorites, source: :track
  has_many :play_lists, dependent: :destroy

  validates :name, presence: true

  def get_profile_image
    (profile_image.attached?) ? profile_image : "no_image.jpg"
  end

  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
       user.password = SecureRandom.urlsafe_base64
       user.name = "guestuser"
    end
  end

  def guest?
    email == GUEST_EMAIL
  end

  def create_play_list(params)
    # プレイリストのタイトルを入れたものを生成する
    # user_idは、自分自身のモデルのため、自動で補完される
    # 例) #<PlayList:0x00007f09b016c978 id: nil, title: "元気になりたい時に聞くプレイリスト", user_id: 31, created_at: nil, updated_at: nil>
    play_list = play_lists.new(title: params[:title])
    # paramsで渡ってきたtrack_idsが空でなければ以下の処理をする
    if params[:track_ids].present?
      # track_idsをループでplay_list.line_itemsにtrack_idを事前準備する。親モデルに紐ずくモデルをnewしたい時はbuildを使う
      params[:track_ids].each { |track_id| play_list.line_items.build(track_id: track_id) }
    end
    # プレイリストを保存する
    play_list.save
    # プレイリストの保存したデータを返す(※1)新しく作ったプレイリストを呼び出し元に返す。
    play_list
  end
end
