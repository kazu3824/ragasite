class Public::PlayListsController < ApplicationController
  def new
    @play_list = PlayList.new
  end

  def show
    @play_list = PlayList.preload(:tracks).find(params[:id])
    @tracks = @play_list.tracks
  end

  def create

    #送られてきたタイトルのプレイリストを作成する
    @play_list = current_user.play_lists.new(play_list_params)
    #play_listのtrack_idsを一旦track_idsに入れている
    track_ids = params[:play_list][:track_ids]
    # track_idsのデータがあってなおかつ、保存が成功したならば
    if track_ids.any? && @play_list.save
      #保存するtrack_idsを一件ずつ
      track_ids.each do |track_id|
        #選曲したidをプレイリストのラインアイテムに新規で保存する
        @play_list.line_items.order(position: :asc).create(track_id: track_id)
      end
      #保存完了後詳細ページに戻る
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
    # track_idsの配列を数値から文字列に変換する
    old_track_ids = @play_list.track_ids&.map(&:to_s)
    # play_listのtrack_idsを一旦track_idsに入れている
    track_ids = params[:play_list][:track_ids]
    # もしtrack_idsが送信されていれば
    if track_ids.any?
      # 送信されてきたトラックidsから現在存在するtrack_idsを除いたトラックidsをnewとする
      insert_list = track_ids - old_track_ids
      # 新しくなるプレイリストに存在しないidをdestroyする
      delete_list = old_track_ids - track_ids
      # 保存するリストを一件ずつ
      insert_list.each do |track_id|
        #新規投稿する
        @play_list.line_items.find_or_create_by(track_id: track_id)
      end
       # ラインアイテムに登録されている削除したいtrack_idを探してdestroyする
      LineItem.where(track_id: delete_list).destroy_all
      redirect_to public_play_list_url(@play_list), notice: "プレイリストを編集しました"
    else
      render :edit
    end
  end

  def destroy
    @play_list = PlayList.find(params[:id])
    if @play_list
      @play_list.destroy
    end
    redirect_to public_user_url(current_user), notice: "プレイリストを削除しました"
  end

  private

  def play_list_params
    params.require(:play_list).permit(:title)
  end
end
