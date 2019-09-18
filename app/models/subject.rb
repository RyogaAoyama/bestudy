class Subject < ApplicationRecord
  belongs_to :room

  validates :name, :presence, length: { maximum: 20 }, uniqueness: true
end
