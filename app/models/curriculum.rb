class Curriculum < ApplicationRecord
  belongs_to :room
  has_many   :result, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }

  def self.get_curriculums
    curriculums = owner_room.curriculum
  end
end
