class Admin::SubjectsController < ApplicationController
  def index
    @subjects = owner_room.subject.where(is_deleted: false)
  end

  def new
    @subject = Subject.new
  end

  def edit
    @subject = Subject.find(params[:id])
  end

  def create
    @subject = owner_room.subject.new(subject_params)
    p @subject
    if @subject.save
      flash[:notice] = "「#{ @subject.name }」を登録しました"
      redirect_to admin_subjects_url
    else
      render :new
    end
  end

  def update
    @subject = Subject.find(params[:id])
    if @subjeyct.update(subject_params)
      flash[:notice] = "科目を更新しました"
      redirect_to admin_subjects_url
    else
      render :edit
    end
  end

  def set_deleted
    subject = Subject.find(params[:id])
    subject.update(is_deleted: true)
    flash[:alert] = "「#{ subject.name }」を削除しました"
    redirect_to admin_subjects_url
  end

  private
  
  def subject_params
  params.require(:subject).permit(:name)
  end
end
