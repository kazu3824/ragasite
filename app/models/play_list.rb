class PlayList < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :tracks, through: :line_items

  validates :title, presence: true


  def update_relations(new_track_ids)
    # self = 呼び出し元
    # 自分自身に紐づいたtracksのIDを一撃で取得して、配列に変換する。
    # モデル名_ids(idsメソッド)でそのIDだけを取得できる。https://qiita.com/Jackson123/items/d37dad86ee892103b7f4
    # 同じ挙動は、track_idsでもtracks.idsでも実装できる。selfは呼び出し元になるので@play_listと同じ意味
    # old_track_ids = self.track_ids&.map(&:to_s)
    old_track_ids = self.track_ids
    # 新しく渡されたtrack_idsとすでに保存されているtrack_ids(old_track_ids)を
    # 引き算して重複を取り除いて重複しないものを中間テーブルに登録する数字が同じものは取り除いている
    # 以前はチェックを入れていなかった新しいnew_track_idsをeachに入れている。line_items=self.line_items self=@play_list
    # 元々なかったけど新しく追加
    new_track_ids.each { |track_id| self.line_items.find_or_create_by(track_id: track_id) }
    # 中間テーブルにある、古いtrack_idsをidsの引き算をしてwhere検索して該当するレコードすべてを削除する。line_items=self.line_items self=@play_list
    # 元々あったけど更新時にチェックを外したものを削除する
    self.line_items.where(track_id: old_track_ids - new_track_ids).destroy_all
  end
end
