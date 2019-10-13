class PointNotice < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :special_point, optional: true

  self.inheritance_column = :_type_disabled
end
