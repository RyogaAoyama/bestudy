class ApplicationController < ActionController::Base
  helper_method :get_validate_msg, :current_user

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

  def no_correct_access
    unless current_user
      redirect_to login_url
    end
  end
end
