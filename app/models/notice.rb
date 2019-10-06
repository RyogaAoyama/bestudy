class Notice < ApplicationRecord
  belongs_to :user
  belongs_to :room

  self.inheritance_column = :_type_disabled
end
