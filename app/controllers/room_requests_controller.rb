# ルーム申請のコントローラー
class RoomRequestsController < ApplicationController
  def new
    @is_applied = RoomRequest.find_by(user_id: current_user.id)
    @room_request = RoomRequest.new
  end

  def create_modal
    room_applied = RoomRequest.find_by(user_id: current_user.id)
    @room = Room.find(room_applied.room_id)
  end

  def create
    # build_room_request使ったら既にあるレコードが削除されるからnewで更新
    @room_request = RoomRequest.new(room_requets_params)
    @room_request.user_id = current_user.id
    
    if @room_request.set_room
      current_user.room_request&.destroy
      @room_request.save

      room = Room.find_by(regist_id: @room_request.regist_id)
      flash[:notice] = "#{ room.name }に申請を出しました"
      redirect_to acount_path(current_user)

      Notice.new(
        user_id: current_user.id,
        room_id: room.id,
        type: 3
      ).save!
    else
      @is_applied = RoomRequest.find_by(user_id: current_user.id)
      render :new
    end
  end

  def destroy
    if Room.user_exit?(current_user)
      flash[:alert] = "ルームから脱退しました"
      redirect_to root_path
    else
      flash[:alert] = '削除に失敗しました。時間をおいて再度お試しください。'
      redirect_to root_path acount_path(current_user)
    end
  end

  private

  def room_requets_params
    params.require(:room_request).permit(:regist_id)
  end
end
