# コントローラ共通クラス
class ApplicationController < ActionController::Base
  helper_method :get_validate_msg, :current_user
  before_action :no_correct_access

  # エラーメッセージがあった場合エラーメッセージを返却
  def get_validate_msg(model, key)
    model.errors.full_messages_for(key).first if model.errors.present?
  end

  # ログイン中のユーザー情報を取得
  def current_user
    @current_user ||= User.find_by(id: session[:id]) if session[:id]
  end

  # ログイン中のユーザーのポイント情報を取得
  def current_point
    @current_point ||= Point.find_by(user_id: session[:id]) if session[:id]
  end

  # 管理人ユーザーが持っているルームを取得
  def owner_room
    @owner_room ||= Room.find_by(user_id: current_user.id) if session[:id]
  end

  # 所属しているルームを取得
  def join_room
    @join_room ||= Room.find_by(id: current_user&.room_id) if session[:id]
  end

  # 認証していないユーザーからのアクセスをブロック
  def no_correct_access
    redirect_to login_url unless current_user
  end

  # セッションを削除する
  def session_destroy
    session.delete(:id) if session[:id]
  end
end
