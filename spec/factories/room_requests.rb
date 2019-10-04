FactoryBot.define do
  factory :room_request do
    association :user, factory: :new_nomal_user
  end
end
