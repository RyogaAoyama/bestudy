class ApplicationController < ActionController::Base
  helper_method :get_validate_msg
  
  # エラーメッセージがあった場合エラーメッセージを返却
  def get_validate_msg( model, key )
    if @user.errors.present?
      @user.errors.full_messages_for( key ).first
    end
  end
end
