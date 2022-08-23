class Public::ArtistsController < ApplicationController
  def show
    @artist = Artist.find(params[:id])
    @tracks = @artist.tracks
    # Kaminariの配列版を使用して@tracksをページネーションする
    @tracks = Kaminari.paginate_array(@tracks).page(params[:page]).per(10)
    # リクエストに応じてビューの切り替え
    respond_to do |format|
      format.html # 非同期通信でない場合はhtml.erbを呼ぶ
      format.js # 非同期の場合はjs.erbを呼ぶ
    end
  end
end
