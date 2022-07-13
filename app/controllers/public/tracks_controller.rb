class Public::TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @track = Track.new
    @track.build_artist
    @user = current_user
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def create
    @track = Track.new(track_params)
    @track.user_id = current_user.id
   if @track.save
    redirect_to public_tracks_path(@track)
   else
    @tracks = Track.all
    render :index
   end
  end

  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      redirect_to public_track_path(@track)
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
    params.require(:track).permit({:artist_attributes => :name}, :tag_id, :description, :url, :title)
  end


  def ensure_correct_user
    @track = Track.find(params[:id])
    unless @track.user = current_user
      redirect_to public_track_path
    end
  end
end
