class Admin::AcountsController < ApplicationController
  def new
    @user = User.new
  end

  def show
  end

  def edit_profile
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      # ルーム作成の時に一緒にユーザーを登録するため
      # 一旦セッションにユーザー情報格納
      session[:user] = @user
      redirect_to new_admin_room_url
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_acount_url(params[:id])
    else
      render :edit_profile
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :name,
      :login_id,
      :password,
      :password_confirmation,
      :secret_question_id,
      :answer,
      :is_admin,
      :image
    )
  end
end
