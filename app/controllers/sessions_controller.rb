class SessionsController < ApplicationController
  def index
  end

  def login
    @user = User.new
  end

  def logout
    session[:id] = nil
    flash[:alert] = 'ログアウトしました。'
    redirect_to root_url
  end

  def create
    login_data = get_login_form
    user = User.find_by(login_id: login_data[:login_id])
    if user&.authenticate(login_data[:password])
      session[:id] = user.id
      flash[:notice] = "ログインに成功しました。ようこそ、#{ user.name }さん！"
      redirect_to products_path(user)
    else
      @user = User.new(login_id: login_data[:login_id])
      flash[:alert] = 'ログインIDとパスワードが一致しません'
      render :login
    end
  end

  private
  def get_login_form
    params.require(:user).permit(:login_id, :password)
  end
end
