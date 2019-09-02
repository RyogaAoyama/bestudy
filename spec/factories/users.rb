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
end
