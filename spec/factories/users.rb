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
    room_id { 1 }
  end

  factory :new_nomal_user, class: User do
    association :secret_question, factory: :new_secret_question
    id { 4 }
    name { "テストユーザー3" }
    login_id { "test_user3" }
    answer { "大元小学校" }
    password { "test_user3" }
    is_admin { false }
  end

  factory :new_admin_user, class: User do
    association :secret_question, factory: :new_secret_question2
    name { "管理ユーザー１" }
    login_id { "admin_user1" }
    answer { "大元小学校" }
    password { "admin_user1" }
    is_admin { true }
  end
end
