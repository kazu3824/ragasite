class Public::ArtistsController < ApplicationController
  def show
     @artist = Artist.find(params[:id])
     @tracks = @artist.tracks
  end
end
