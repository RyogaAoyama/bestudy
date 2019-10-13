# 特別ポイントのコントローラー
class Admin::SpecialPointsController < ApplicationController
  def index
    @users = User.where(room_id: owner_room.id)
  end

  def new
    @special_point = SpecialPoint.new
  end

  def create
    @special_point = SpecialPoint.new(special_point_params)
    @special_point.assign_attributes(
      user_id: params[:acount_id],
      room_id: owner_room.id
    )
    # int型に型に文字型を入れたら0に自動変換されてしまうためされてしまうためパラメータを再代入
    @special_point.point = @special_point.half_size_change(special_point_params[:point])
    if @special_point.save
      point = Point.find_by(user_id: params[:acount_id])
      point.point += @special_point.point
      point.save
      flash[:notice] = "#{ User.find(params[:acount_id]).name }に特別ポイントを送りました"
      redirect_to admin_special_points_path
      
      PointNotice.new(
        user_id: params[:acount_id],
        room_id: owner_room.id,
        get_point: @special_point.point,
        special_point_id: @special_point.id,
        type: 2
      ).save
    else
      render :new
    end
  end

  private

  def special_point_params
    params.require(:special_point).permit(
      :point,
      :message
    )
  end
end
