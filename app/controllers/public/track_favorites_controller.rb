class Public::TrackFavoritesController < ApplicationController
  def create
    track = Track.find(params[:track_id])
    track_favorite = current_user.track_favorites.new(track_id: track.id)
    track_favorite.save
    redirect_to request.referer
  end

  def destroy
    track = Track.find(params[:track_id])
    track_favorite = current_user.track_favorites.find_by(track_id: track.id)
    track_favorite.destroy
    redirect_to request.referer
  end
  
  def index
    favorites = TrackFavorite.where(user: current_user).pluck(:track_id)
    @tracks = Track.find(favorites)
  end
end
