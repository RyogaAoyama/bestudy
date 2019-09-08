class ApplicationController < ActionController::Base
  helper_method :get_validate_msg, :current_user
  before_action :no_correct_access

  # エラーメッセージがあった場合エラーメッセージを返却
  def get_validate_msg( model, key )
    if model.errors.present?
      model.errors.full_messages_for( key ).first
    end
  end

  # ログイン中のユーザー情報を取得
  def current_user
    if session[:id]
      @current_user ||= User.find_by(id: session[:id])
    end
  end

  # 管理人ユーザーが持っているルームを取得
  def owner_room
    if session[:id]
      @owner_room ||= Room.find_by(user_id: current_user.id)
    end
  end

  # 認証していないユーザーからのアクセスをブロック
  def no_correct_access
    unless current_user
      redirect_to login_url
    end
  end
end
