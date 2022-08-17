class Public::SearchesController < ApplicationController
  def search_tag
    # tagを選択されていない場合
    unless params["track"]["tag_id"].present?
      # 曲一覧画面に戻る
      redirect_to public_tracks_path
      return
    end
    # トラックテーブルからトラックに紐付いているtag_idを指定してtrackを取得する
    @tracks = Track.where(tag_id: params["track"]["tag_id"])

    # tagテーブルからtag_idを指定してnameを取得する
    @seach_word = Tag.find(params[:track][:tag_id]).name
    render 'public/searches/index'
  end

  def search_keyword
    # トラックテーブルとアーティストテーブルを同時に指定して曲名と概要と歌手名とタグ名中に,パラメーターとして送られてきたキーワードに一致するデータがあれば取得する
    @tracks = Track.joins(:artist, :tag)
              .where("tracks.title like ? or tracks.description like ? or artists.name like ? or tags.name like ?",
              "%" + params["track"]["keyword"] + "%",
              "%" + params["track"]["keyword"] + "%",
              "%" + params["track"]["keyword"] + "%",
              "%" + params["track"]["keyword"] + "%")
    # パラメーターとして送られてきたキーワードをseach_wordに代入している
    @seach_word = params[:track][:keyword]
    render 'public/searches/index'
  end
end
