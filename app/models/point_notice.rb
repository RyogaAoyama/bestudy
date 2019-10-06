class PointNotice < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :special_point

  self.inheritance_column = :_type_disabled
end
