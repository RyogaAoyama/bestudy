FactoryBot.define do
  factory :notice do
    trait :room_request_ok do
      type { 1 }
    end

    trait :product_request_ok do
      type { 2 }
    end

    trait :room_request_send do
      type { 3 }
    end

    trait :product_buy do
      type { 4 }
    end

    trait :product_request_send do
      type { 5 }
    end
  end
end
