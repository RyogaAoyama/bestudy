FactoryBot.define do
  factory :curriculum do
    name { "科目名" }
    is_deleted { false }
  end

  factory :curriculum_sequence, class: Curriculum do
    sequence(:name) { |i| "科目名#{ i }" }
    is_deleted { false }
  end
end
