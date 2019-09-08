FactoryBot.define do
  factory :user do
    id { 1 }
    name { "テストユーザー１" }
    login_id { "test_user1" }
    answer { "大元小学校" }
    password { "test_user1" }
    is_admin { true }
    secret_question_id { 1 }
  end

  factory :nomal_user, class: User do
    id { 2 }
    name { "テストユーザー2" }
    login_id { "test_user2" }
    answer { "大元小学校" }
    password { "test_user2" }
    is_admin { false }
    secret_question_id { 1 }
  end
end
