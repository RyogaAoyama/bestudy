module CommonHelper
  def create_room
    FactoryBot.create(:secret_question)
    user = FactoryBot.create(:user)
    room = FactoryBot.create(:room)
    user.room_id = room.id
    return room
  end

  def remove_room
    Room.find(1).destroy
    User.find(1).destroy
    SecretQuestion.find(1).destroy
  end

  def create_product
    FactoryBot.create(:secret_question)
    FactoryBot.create(:user)
    FactoryBot.create(:product)
  end
end