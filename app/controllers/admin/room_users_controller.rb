# ルームに所属するユーザー一覧のコントローラー
class Admin::RoomUsersController < ApplicationController
  def index
    @users = User.where(room_id: owner_room.id)
  end

  def destroy
    user = User.find(params[:id])
    flash[:alert] = if Room.user_exit?(user)
                      "#{ user.name }をルームから退会させました"
                    else
                      '削除に失敗しました。時間をおいて再度お試しください。'
                    end
    redirect_to admin_room_users_url
  end
end
