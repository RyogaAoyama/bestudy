FactoryBot.define do
  factory :order_history do
    trait :association do
      association :room, factory: :new_room2
      association :user, factory: :new_nomal_user
      association :product, factory: :new_product2
    end
    is_order_success { false }
  end
end
