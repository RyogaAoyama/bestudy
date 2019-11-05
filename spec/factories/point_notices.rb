FactoryBot.define do
  factory :point_notice do
    get_point { 100 }
    type { 1 }
    special_point { nil }
  end
end
