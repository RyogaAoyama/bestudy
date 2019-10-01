# ルーム承認のコントローラー
class Admin::RoomRequestsController < ApplicationController
  def index
    @room_requests = owner_room.room_request
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    user = User.find(params[:id])
    user.room_id = owner_room.id
    user.save

    RoomRequest.find_by(user_id: user.id).destroy

    # TODO:お知らせ機能もそのうち
    flash[:notice] = "#{ user.name }を承認しました"
    redirect_to admin_room_requests_url
  end

  def destroy
    user = User.find(params[:id])
    RoomRequest.find_by(user_id: user.id).destroy

    flash[:alert] = "#{ user.name }を拒否しました"
    redirect_to admin_room_requests_url
  end
end
