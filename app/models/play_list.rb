class PlayList < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :tracks, through: :line_items

  validates :title, presence: true

  def self.create_by_user(user, params)
    # プレイリストのタイトルを入れたものを生成する
    # 例) #<PlayList:0x00007f09b016c978 id: nil, title: "元気になりたい時に聞くプレイリスト", user_id: 31, created_at: nil, updated_at: nil>
    play_list = new(title: params[:title])
    # 引数で渡されたuserをbelongs_to :userに設定している。右辺でのuserはあらかじめ定義したuser←コントローラーでcurrent_userで渡す。
    play_list.user = user
    # paramsで渡ってきたtrack_idsが空でなければ以下の処理をする。present?は変数に値が入っていればtrueを返し値が存在しない時は、falseを返す。
    if params[:track_ids].present?
      # track_idsをループでplay_list.line_itemsにtrack_idを事前準備する。親モデルに紐ずくモデルをnewしたい時はbuildを使う
      params[:track_ids].each { |track_id| play_list.line_items.build(track_id: track_id) }
    end
    # プレイリストを保存する
    play_list.save
    # プレイリストの保存したデータを返す(※1)新しく作ったプレイリストを呼び出し元に返す。#return play_list
    play_list
  end

  def update_relations(track_ids)
    # 自分自身に紐づいたtracksのIDを一撃で取得して、配列に変換する。
    # モデル名_ids(idsメソッド)でそのIDだけを取得できる。https://qiita.com/Jackson123/items/d37dad86ee892103b7f4
    # 同じ挙動は、track_idsでもtracks.idsでも実装できる。
    old_track_ids = self.track_ids&.map(&:to_s)
    # 新しく渡されたtrack_idsとすでに保存されているtrack_ids(old_track_ids)を
    # 引き算して重複を取り除いて重複しないものを中間テーブルに登録する
    (track_ids - old_track_ids).each { |track_id| line_items.find_or_create_by(track_id: track_id) }
    # 中間テーブルにある、古いtrack_idsをidsの引き算をしてwhere検索して該当するレコードすべてを削除する
    LineItem.where(track_id: old_track_ids - track_ids).destroy_all
  end
end
