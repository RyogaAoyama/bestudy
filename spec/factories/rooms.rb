FactoryBot.define do
  factory :room do
    id { 1 }
    regist_id { "test_room" }
    name { "test_room" }
    user_id { 1 }
  end
  factory :new_room, class: Room do
    association :user, factory: :new_admin_user
    regist_id { "test_room2" }
    name { "test_room2" }
  end
end
