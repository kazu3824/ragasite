class Public::TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    to = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @tracks = Track.all.sort {|a,b|
      b.track_favorites.where(created_at: from...to).size <=>
      a.track_favorites.where(created_at: from...to).size
    }
    @track = Track.new
    @track.build_artist
    @user = current_user
    @search_tag = Track.new
  end

  def show
    @track = Track.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @track = Track.find(params[:id])
    @track.artist_name = @track.artist.name
  end

  def create
    # アーティストを歌手テーブルから歌手名で検索する
    # find_or_create_byはアーティストを探しても見つからない場合は新しく作って保存する
    artist = Artist.find_or_create_by(name: params[:track][:artist_name])
    # 保存したいtrackの情報+artist_id
    @track = Track.new(track_params.merge(artist_id: artist.id))
    @track.user_id = current_user.id
   if @track.save
    redirect_to public_track_path(@track), notice: "曲を投稿しました"
   else
    @tracks = Track.all
    render :index
   end
  end

  def update
    @track = Track.find(params[:id])
    # アーティストを歌手テーブルから歌手名で検索する
    # find_or_create_byはアーティストを探しても見つからない場合は新しく作って保存する
    artist = Artist.find_or_create_by(name: params[:track][:artist_name])
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
    params.require(:track).permit(:title, :tag_id, :description, :url, :artist_name)
  end


  def ensure_correct_user
    @track = Track.find(params[:id])
    unless @track.user = current_user
      redirect_to public_track_path
    end
  end

end
