class Admin::RoomsController < ApplicationController
  skip_before_action :no_correct_access, only: [:new, :create]
  def new
    @room = Room.new
  end

  def show
  end

  def edit_name
    @room = current_user.room
  end

  def update_name
    @room = current_user.room
    if @room.update(room_params)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_room_url(params[:id])
    else
      render :edit_name
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :regist_id)
  end
end
