# 科目機能のコントローラー
class Admin::CurriculumsController < ApplicationController
  def index
    @curriculums = owner_room.curriculum.where(is_deleted: false)
  end

  def new
    @curriculum = Curriculum.new
  end

  def edit
    @curriculum = Curriculum.find(params[:id])
  end

  def create
    @curriculum = owner_room.curriculum.new(curriculum_params)
    if @curriculum.save
      flash[:notice] = "「#{ @curriculum.name }」を登録しました"
      redirect_to admin_curriculums_url
    else
      render :new
    end
  end

  def update
    @curriculum = Curriculum.find(params[:id])
    if @curriculum.update(curriculum_params)
      flash[:notice] = '科目を更新しました'
      redirect_to admin_curriculums_url
    else
      render :edit
    end
  end

  def destroy_modal
    @curriculum = Curriculum.find(params[:id])
  end

  def set_deleted
    curriculum = Curriculum.find(params[:id])
    curriculum.update(is_deleted: true)
    flash[:alert] = "「#{ curriculum.name }」を削除しました"
    redirect_to admin_curriculums_url
  end

  private

  def curriculum_params
    params.require(:curriculum).permit(:name)
  end
end
