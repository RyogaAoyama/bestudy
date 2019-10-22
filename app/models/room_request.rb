class RoomRequest < ApplicationRecord
  belongs_to :user
  belongs_to :room

  attr_accessor :regist_id

  def set_room
    room = Room.find_by(regist_id: regist_id)
    room_request = RoomRequest.find_by(user_id: user_id)

    if room.nil?
      errors.add(:regist_id, 'が存在しません')
      false
    elsif room.id == room_request&.room_id
      errors.add(:regist_id, 'は既に申請済みです')
      false
    else
      self.room_id = room.id
      true
    end
  end
end
