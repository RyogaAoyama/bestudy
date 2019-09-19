class Curriculum < ApplicationRecord
  belongs_to :room

  validates :name, presence: true, length: { maximum: 20 }
end
