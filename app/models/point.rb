# ポイントモデル
class Point < ApplicationRecord
  belongs_to :user

  include PointCalc

  # ---------------------------------- #
  # 機能：ポイントを計算する
  # 引数:(商品の値段)
  # 返却:ポイントオブジェクト
  # ---------------------------------- #
  def buy_calc(product_point)
    result = point - product_point
    if !result.negative?
      self.point -= product_point
      self.total += product_point
    else
      false
    end
  end
end
