# frozen_string_literal: true

module NoticeDecorator
  def disp_notice
    case type
    when 1
      "ルーム申請が承諾されました！"
    when 2
      "リクエストした商品が採用されました"
    when 3
      "#{ User.find(user_id).name }が入室の許可を求めています。"
    when 4
      "#{ User.find(user_id).name }が商品を購入しました。商品を届けましょう！"
    when 5
      "#{ User.find(user_id).name }から商品リクエストが届いてます。"
    end
  end
end
