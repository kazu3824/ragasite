class Public::SearchesController < ApplicationController
  def search_tag
    # tag_idのパラメーターが渡ってきてなければ

    unless params[:track][:tag_id].present?
      # 検索せずに曲一覧画面に戻る
      redirect_to public_tracks_path
      return
    end
    # トラックテーブルからトラックに紐付いているtag_idを指定してtrackを取得する
    @tracks = Track.where(tag_id: params[:track][:tag_id])
    # tagテーブルからtag_idを指定してnameを取得する
    @seach_word = Tag.find(params[:track][:tag_id]).name
    # Kaminariの配列版を使用して@tracksをページネーションする
    @tracks = Kaminari.paginate_array(@tracks).page(params[:page]).per(10)
    # リクエストに応じてビューの切り替え
    respond_to do |format|
      format.html {render 'public/searches/index'}# 非同期通信でない場合はhtml.erbを呼ぶ
      format.js {render 'public/searches/index'} # 非同期の場合はjs.erbを呼ぶ
    end

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
    # Kaminariの配列版を使用して@tracksをページネーションする
    @tracks = Kaminari.paginate_array(@tracks).page(params[:page]).per(10)
    # リクエストに応じてビューの切り替え
    respond_to do |format|
      format.html {render 'public/searches/index'}# 非同期通信でない場合はhtml.erbを呼ぶ
      format.js {render 'public/searches/index'} # 非同期の場合はjs.erbを呼ぶ
    end
  end

end
