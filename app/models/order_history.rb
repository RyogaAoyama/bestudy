class OrderHistory < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :product
  has_one    :delivery
end
