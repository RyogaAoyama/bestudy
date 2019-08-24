class Admin::AcountsController < ApplicationController
  def new
    @user = User.new
  end

  def show
  end

  def edit_profile
    @user = User.find(params[:id])
  end

  def authentication
    @user = current_user
  end

  def edit_password
    @user = User.new(user_params)
    if current_user&.authenticate(@user.password)
      @user = current_user
    else
      flash[:alert] = 'パスワードが一致しません'
      # TODO:renderでやると認証画面で更新かけたときにルーティングエラーでる。URLがedit_passwordに変わるから
      redirect_to authentication_admin_acount_path(current_user)
    end
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

  # パスワードをアップデート
  def update_password
    @user = User.find(params[:id])
    @user.attributes = ({
      password: user_params[:password],
      password_confirmation: user_params[:password_confirmation]
    })
    if @user.save(context: :password_only)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_acount_url(params[:id])
    else
      render :edit_password
    end
  end

  # パスワード以外アップデート。
  # パスワードのバリデーションもかけてしまうとバリデーションエラーが出るため分けている。
  # モデルでパスワードのバリデーションを無効にしている
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