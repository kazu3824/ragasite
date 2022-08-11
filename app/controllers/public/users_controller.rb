class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @tracks = @user.tracks
    # Kaminariの配列版を使用して@tracksをページネーションする
    @tracks = Kaminari.paginate_array(@tracks).page(params[:page]).per(5)
    @play_lists = @user.play_lists
    # リクエストに応じてビューの切り替え
    respond_to do |format|
      format.html # 非同期通信でない場合はhtml.erbを呼ぶ
      format.js # 非同期の場合はjs.erbを呼ぶ
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to public_user_path(@user), notice: "プロフィールを編集しました"
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end


  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
        redirect_to public_user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
