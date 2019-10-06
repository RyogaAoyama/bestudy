class Point < ApplicationRecord
  belongs_to :user

  include PointCalc
end
