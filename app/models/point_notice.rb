class PointNotice < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :special_point, optional: true

  self.inheritance_column = :_type_disabled

  def detail
    case type
    when 1
      return "成績が評価され、ポイントが付与されました。"
    when 2
      return "あなたの日々の頑張りが評価され、ポイントが付与されました。"
    when 3
      return "テスト結果が評価され、ポイントが付与されました。"
    end
  end
end
