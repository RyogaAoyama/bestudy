FactoryBot.define do
  factory :point_notice do
    get_point { 1 }
    type { 1 }
    room { nil }
    user { nil }
    special_point { nil }
  end
end
