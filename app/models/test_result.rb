class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :curriculum
end
