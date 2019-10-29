# 注文履歴のコントローラー
class OrderHistoriesController < ApplicationController
  def index
    @order_histories = OrderHistory.where(user_id: current_user.id)
  end
end
