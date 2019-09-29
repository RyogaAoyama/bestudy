class Point < ApplicationRecord
  belongs_to :user, dependent: :destroy

  include PointCalc
end
