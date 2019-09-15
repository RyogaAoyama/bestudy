class Delivery < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :room
  belongs_to :order_history
end
