class Admin::TracksController < ApplicationController
  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to admin_user_path(@track.user.id)
  end
end
