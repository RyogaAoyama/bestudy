# 購入コントローラー
class BuysController < ApplicationController
  def create_modal
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.find(params[:id])
    point = current_point

    if point.buy_calc(@product.point)
      Point.transaction do
        # データを保存

        # ポイント
        point.save!

        # 注文履歴
        order_history = OrderHistory.new(
          user_id: current_user.id,
          room_id: current_user.room_id,
          product_id: @product.id,
          is_order_success: false
        )
        order_history.save!

        # お知らせ
        notice = Notice.new(
          user_id: current_user.id,
          room_id: current_user.room_id,
          type: 4
        )
        notice.save!

        # デリバリー
        delivery = Delivery.new(
          user_id: current_user.id,
          room_id: current_user.room_id,
          product_id: @product.id,
          order_history_id: order_history.id
        )
        delivery.save!
      end

      flash[:notice] = "#{ @product.name }を購入しました。"
    else
      flash[:alert] = 'ポイントが足りません。'
    end
    redirect_to products_url(current_user)

    # transactionの例外をキャッチ
  rescue StandardError
    p $ERROR_INFO
    flash[:alert] = '通信に失敗しました。時間をおいて再度お試しください。'
    redirect_to products_path(current_user)
  end
end
