class Admin::AcountsController < ApplicationController
  skip_before_action :no_correct_access, only: [:new, :create]
  before_action :session_destroy, only: [:new]
  def new
    @user = User.new
    @room = Room.new
  end

  def edit_profile
    @user = current_user
  end

  def authentication
    @user = current_user
  end

  def authentication_question
    @user = current_user
  end

  def edit_question
    @user = User.new(user_params)
    if current_user&.authenticate(@user.password)
      @user = current_user
    else
      flash[:alert] = 'パスワードが一致しません'
      redirect_to authentication_admin_acount_path(current_user)
    end
  end

  def edit_password
    @user = User.new(user_params)
    if current_user&.authenticate(@user.password)
      @user = current_user
    else
      flash[:alert] = 'パスワードが一致しません'
      redirect_to authentication_admin_acount_path(current_user)
    end
  end

  def create
    @user = User.new(user_params)
    @room = Room.new(room_params)
    @user.default_image_set
    # rubyの仕様でfalseの瞬間判定値が返却されるためvalidを先に実行
    # 何か良いやり方ないかな
    @room.valid?
    if @user.valid? && @room.valid?
      @user.save
      @room.user_id = @user.id
      @room.save
      flash[:notice] = "登録が完了しました。ようこそ！#{ @user.name }さん！"
      session[:id] = @user.id
      redirect_to admin_products_url
    else
      render action: :new
    end
  end

  # パスワードをアップデート
  def update_password
    @user = User.find(params[:id])
    @user.attributes = ({
      password:              user_params[:password],
      password_confirmation: user_params[:password_confirmation]
    })
    if @user.save(context: :password_only)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_acount_url(params[:id])
    else
      render :edit_password
    end
  end

  # 名前とプロフィール画像の保存
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_acount_url(params[:id])
    else
      render :edit_profile
    end
  end

  # 秘密の質問アップデート
  def update_question
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_acount_url(params[:id])
    else
      render :edit_question
    end
  end

  def destroy
    room_id = owner_room.id
    if current_user.destroy
      p User.where(room_id: room_id).update_all(room_id: '')
      p "aaa"
      p Point.where(room_id: room_id).update_all(point: 0, total: 0)
      flash[:alert] = 'アカウントを削除しました。ご利用ありがとうございました！'
      redirect_to root_path
      session[:id] = nil
    else
      flash[:alert] = '削除に失敗しました。時間をおいて再度お試しください。'
      redirect_to admin_acount_url(current_user)
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

  def room_params
    params.require(:room).permit(:name, :regist_id)
  end
end
