class Public::TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @track = Track.new
  end

  def index
    # track.rbで定義したsort_by_conditionを呼び出している
    @tracks = Track.sort_by_condition(params)
    @search_tag = Track.new
    # Kaminariの配列版を使用して@tracksをページネーションする
    @tracks = Kaminari.paginate_array(@tracks).page(params[:page]).per(10)
    # リクエストに応じてビューの切り替え
    respond_to do |format|
      format.html # 非同期通信でない場合はhtml.erbを呼ぶ
      format.js # 非同期の場合はjs.erbを呼ぶ
    end
  end

  def show
    @track = Track.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @track = Track.find(params[:id])
  end

  def create
    # アーティストを歌手テーブルから歌手名で検索する
    # find_or_create_byはアーティストを探しても見つからない場合は新しく作って保存する
    artist = Artist.find_or_create_by(name: params[:track][:artist_name])
    # track_paramsにartist_idを追加して、trackを新規作成する
    @track = Track.new(track_params.merge(artist_id: artist.id))
    @track.user_id = current_user.id
    if @track.save
      redirect_to public_track_path(@track), notice: "曲を投稿しました"
    else
      # こちらはarray型ではないのでページを実行してページネーションする。
      @tracks = Track.all.page(params[:page]).per(10)
      render :new
    end
  end

  def update
    @track = Track.find(params[:id])
    # アーティストを歌手テーブルから歌手名で検索する
    # find_or_create_byはアーティストを探しても見つからない場合は新しく作って保存する
    artist = Artist.find_or_create_by(name: params[:track][:artist_name])
     # track_paramsにartist_idを追加して、trackを更新する
    if @track.update(track_params.merge(artist_id: artist.id))
      redirect_to public_track_path(@track), notice: "投稿を編集しました"
    else
      render "edit"
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to public_tracks_path
  end

  private

  def track_params
    params.require(:track).permit(:title, :tag_id, :description, :url)
  end

  def ensure_correct_user
    @track = Track.find(params[:id])
    unless @track.user == current_user
      redirect_to public_track_path
    end
  end
end
