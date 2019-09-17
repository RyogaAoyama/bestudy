FactoryBot.define do
  factory :subject do
    association :room, factory: :new_room
    name { "科目名" }
    is_deleted { false }
  end
end
