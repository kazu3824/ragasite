class Admin::CommentsController < ApplicationController
  def index
    @track = Track.find(params[:track_id])
    @comments = @track.comments
  end

  def destroy
    @track = Track.find(params[:track_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_track_comments_path(@track.id)
  end
end
