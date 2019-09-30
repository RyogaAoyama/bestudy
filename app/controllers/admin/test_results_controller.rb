# テスト入力のコントローラー
class Admin::TestResultsController < ApplicationController
  extend StringTrans
  def index
    @users = User.where(room_id: owner_room.id)
  end

  def new
    @curriculums = owner_room.curriculum.where(is_deleted: false)
    @test_result = TestResult.new
  end

  def create
    @test_result = TestResult.new(test_result_params)
    @test_result.assign_attributes(
      user_id: params[:acount_id],
      room_id: owner_room.id
    )

    @test_result.score = @test_result.half_size_change(test_result_params[:score])
    if @test_result.save
      point = Point.find_by(user_id: params[:acount_id])
      point.point = point.add_point(@test_result.score, point.point)
      point.save
      flash[:notice] = 'テストの登録が完了しました'
      redirect_to admin_test_results_path
      # TODO:お知らせ
    else
      @curriculums = owner_room.curriculum.where(is_deleted: false)
      render :new
    end
  end

  private

  def test_result_params
    params.require(:test_result).permit(:score, :curriculum_id)
  end
end
