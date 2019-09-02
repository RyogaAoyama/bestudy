class SessionsController < ApplicationController
  skip_before_action :no_correct_access
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
    login_data = get_login_params
    user = User.find_by(login_id: login_data[:login_id])
    if user&.authenticate(login_data[:password])
      session[:id] = user.id
      flash[:notice] = "ログインに成功しました。ようこそ、#{ user.name }さん！"
      if user.is_admin
        redirect_to admin_products_path(user)
      else
        redirect_to products_path(user)
      end
    else
      @user = User.new(login_id: login_data[:login_id])
      flash[:alert] = 'ログインIDとパスワードが一致しません'
      render :login
    end
  end

  private
  def get_login_params
    params.require(:user).permit(:login_id, :password)
  end
end
