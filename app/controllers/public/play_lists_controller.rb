class Public::PlayListsController < ApplicationController
  def new
    @play_list = PlayList.new
  end

  def show
    @play_list = PlayList.preload(:tracks).find(params[:id])
    @tracks = @play_list.tracks
  end

  def create
    @play_list = current_user.play_lists.build(play_list_params)
    track_ids = params.dig(:play_list, :track_ids).compact.reject(&:empty?)
    if track_ids.any? && @play_list.save
      track_ids.each do |track_id|
        @play_list.line_items.create!(track_id: track_id)
      end
      redirect_to public_play_list_url(@play_list), notice: "プレイリストを作成しました"
    else
      render :new
    end
  end

  def edit
    @play_list = PlayList.find(params[:id])
  end

  def update
    @play_list = PlayList.find(params[:id])
    old_track_ids = @play_list.track_ids&.map(&:to_s)
    track_ids = params.dig(:play_list, :track_ids).compact.reject(&:empty?)
    sum_track_ids = (old_track_ids + track_ids).uniq
    if track_ids.any?
      insert_list = sum_track_ids.dup
      insert_list.delete_if{|n|old_track_ids.include?(n)}
      delete_list = sum_track_ids.dup
      delete_list.delete_if{|n|track_ids.include?(n)}
      insert_list.each do |track_id|
        @play_list.line_items.find_or_create_by(track_id: track_id)
      end
      LineItem.where(track_id: delete_list).destroy_all
      redirect_to public_play_list_url(@play_list), notice: "プレイリストを編集しました"
    else
      render :edit
    end
  end

  def destroy
    @play_list = PlayList.find(params[:id])
    @play_list.destroy if @play_list
    redirect_to public_user_url(current_user), notice: "プレイリストを削除しました"
  end

  private

  def play_list_params
    params.require(:play_list).permit(:title)
  end
end
