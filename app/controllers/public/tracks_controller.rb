class Public::TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @track = Track.new
    @track.build_artist
    # @track.build_tag
    @user = current_user
    @tracks = Track.all
  end

  def show
  end

  def edit
  end

  def create
    @track = Track.new(track_params)
    @track.user_id = current_user.id
   if @track.save
    redirect_to public_tracks_path(@track)
   else
    @tracks = track.all
    render :index
   end
  end

  def update
  end

  def destroy
  end

  private

  def track_params
  end
end
