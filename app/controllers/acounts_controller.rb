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
    if @user.save
      session[:id] = @user.id
      flash[:notice] = "登録が完了しました。ようこそ！#{ @user.name }さん！"
      redirect_to products_path(@user)
    else
      render :nomal_new
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
      :answer
    )
  end
end
