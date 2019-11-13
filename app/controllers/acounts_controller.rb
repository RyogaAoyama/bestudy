class AcountsController < ApplicationController
  skip_before_action :no_correct_access, only: [:nomal_new, :create, :index]
  before_action :session_destroy, only: [:index, :nomal_new]
  
  def nomal_new
    @user = User.new
  end

  def index
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(get_regist_user)
    @user.default_image_set
    if @user.save
      # ポイントレコード生成
      Point.new(user_id: @user.id, total: 0, point: 0).save

      session[:id] = @user.id
      flash[:notice] = "登録が完了しました。ようこそ！#{ @user.name }さん！"
      redirect_to products_url(@user)
    else
      render :nomal_new
    end
  end

  def destroy
    if current_user.destroy
      flash[:alert] = 'アカウントを削除しました。ご利用ありがとうございました！'
      redirect_to root_path
      session[:id] = nil
    else
      flash[:alert] = '削除に失敗しました。時間をおいて再度お試しください。'
      redirect_to acount_url(current_user)
    end
  end

  private
  def get_regist_user
    params.require(:user).permit(
      :name,
      :login_id,
      :password,
      :password_confirmation,
      :secret_question_id,
      :answer,
      :image
    )
  end
end
