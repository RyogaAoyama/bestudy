# ポイントお知らせのコントローラー
class PointsController < ApplicationController
  def index
    @point_notices = current_user.point_notice
    @point = current_point
  end

  def show
    @point_notice = PointNotice.find(params[:id])
  end
end
