FactoryBot.define do
  factory :notice do
    type { 1 }
    user { nil }
    room { nil }
  end
end
