class Public::PlayListsController < ApplicationController
  before_action :authenticate_user!

  def new
    @play_list = PlayList.new
  end

  def show
    # tracksをあらかじめpreload(:tracks)で読み込んでおく
    @play_list = PlayList.preload(:tracks).find(params[:id])
    @tracks = @play_list.tracks
  end

  def create
    # current_userで生成したcreate_play_listを呼び出し、params[:play_list]のすべてを渡す
    # 戻ってくる値は、User.rbの※1のデータが戻ってくるのでそのデータを@play_listに入れる。（user
    @play_list = PlayList.create_by_user(current_user, play_list_params)
    # @play_listには、保存に成功すればデータが入っているvalid?バリデーションチェックで失敗したかどうかをtrueかfalseで返す。
    if @play_list.valid?
      # 保存に成功していた場合は、リダイレクトする。
      redirect_to public_play_list_path(@play_list), notice: "プレイリストを作成しました"
    else
      # 保存に失敗している場合は、:newをレンダリングする。
      render :new
    end
  end

  def edit
    @play_list = PlayList.find(params[:id])
  end

  def update
   # PlayListを検索し、見つかった最初の1件を取得する
    @play_list = PlayList.find(params[:id])
    # play_listのtrack_idsを一旦track_idsに入れている
    track_ids = play_list_params[:track_ids]
    # @play_listの更新が成功して、かつtrack_idsに何か入っていれば処理をする。present?は存在していたらtrueを返す
    if @play_list.update(title: play_list_params[:title]) && track_ids.present?
      @play_list.update_relations(track_ids) # PlayListモデルで定義したupdate_relationsにnew_track_idsを渡して呼び出して処理をする。
      redirect_to public_play_list_path(@play_list), notice: "プレイリストを編集しました"
    else
      render :edit
    end

  end

  def destroy
    @play_list = PlayList.find(params[:id])
    if @play_list
      @play_list.destroy
    end
    redirect_to public_user_path(current_user), notice: "プレイリストを削除しました"
  end

  private

  # StrongParameterとはPOSTされたデータでpermitで許可されたものだけをplay_list_paramsとして返すもの
  # track_ids: []がどこから来ているか = <input type="checkbox" value="<%= track.id %>" name="play_list[track_ids][]" id="play_list_track_ids_<%= track.id %>">
  def play_list_params
    params.require(:play_list).permit(:title, track_ids: [])
  end
end
