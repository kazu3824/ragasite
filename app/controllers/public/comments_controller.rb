class Public::CommentsController < ApplicationController
  def create
    @track = Track.find(params[:track_id])
    @comment = current_user.comments.new(comment_params)
    @comment.track_id = @track.id
    @comment.save
    redirect_to request.referer
  end

  def destroy
    @track = Track.find(params[:track_id])
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
