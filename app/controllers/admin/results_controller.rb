class Admin::ResultsController < ApplicationController
  def index
    @users = User.where(room_id: owner_room.id)
  end

  def new
    @curriculums = owner_room.curriculum.where(is_deleted: false)
    @results = ResultCollection.new(num: @curriculums.size)
  end

  def create
    @curriculums = owner_room.curriculum.where(is_deleted: false)
    @results = ResultCollection.new(results_params)

    if exist_result?(results_params)
      @results.save(owner_room.id, params[:acount_id])

      # ポイントの計算と保存
      point = Point.find_by(user_id: params[:acount_id])
      get_point = point.result_calc(@results.collection)
      point.point += get_point
      point.save

      # お知らせ
      PointNotice.new(
        user_id: params[:acount_id],
        room_id: owner_room.id,
        get_point: get_point,
        type: 1
      ).save!

      flash[:notice] = '登録が完了しました'
      redirect_to admin_results_url
    else
      flash[:alert] = '成績を入力してください'
      render :new
    end
  end

  private

  def results_params
    params.permit(results: %i[result curriculum_id])[:results].to_hash
  end

  def exist_result?(attributes)
    attributes.any? { |_, value| value.key?('result') }
  end
end
