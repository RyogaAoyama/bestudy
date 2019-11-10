# いいね表示用のモジュール
module GoodsHelper
  def good_active(product)
    # お気に入り商品のみ取得のときはg_user_idメソッドはない
    # ないときはお気に入り状態でハートを表示する
    if !product.respond_to?(:g_user_id)
      'active'
    elsif product.g_user_id.present?
      'active'
    else
      'passive'
    end
  end

  def no_good_active(product)
    # お気に入り商品のみ取得のときはg_user_idメソッドはない
    # ないときはお気に入り状態ではないハートは非表示にする
    if !product.respond_to?(:g_user_id)
      'passive'
    elsif product.g_user_id.nil?
      'active'
    else
      'passive'
    end
  end
end
