class Admin::AcountsController < ApplicationController
  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new( get_regist_user )
    if @user.valid?
      # グループ作成の時に一緒にユーザーを登録するため
      # 一旦セッションにユーザー情報格納
      session[:user] = @user
      redirect_to new_admin_group_url
    else
      render :new
    end
  end

  private
  def get_regist_user
    params.require( :user ).permit( :name, :login_id, :password, :password_confirmation, :secret_question_id, :answer )
  end
end
