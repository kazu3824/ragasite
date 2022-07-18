class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]
  def index

  end

  def show
    # @track = Track.find(params[:id])
     #@tracks = Track.all
     @user = User.find(params[:id])
     @tracks = @user.tracks
     @play_lists = @user.play_lists
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
