class Admin::UsersController < ApplicationController
  
  before_action :admin?
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @tracks = @user.tracks
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path, notice: "#{user.name}が削除されました"
  end
  
  private

  def admin?
    unless admin_signed_in?
      redirect_to root_path
    end
  end
end
