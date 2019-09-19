FactoryBot.define do
  factory :curriculum do
    trait :association do
      association :room, factory: :new_room
    end
    name { "科目名" }
    is_deleted { false }
  end
end
