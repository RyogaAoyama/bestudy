FactoryBot.define do
  factory :user do
    id { 1 }
    name { "テストユーザー１" }
    login_id { "test_user1" }
    answer { "大元小学校" }
    password { "test_user1" }
    is_admin { true }
    secret_question_id { 1 }
    after(:create) do |user|
      File.open('public/test.jpg') do |f|
        user.image.attach(io: f, filename: "test.jpg")
      end
    end
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
    sequence(:name, 3) { |i| "テストユーザー#{ i }" }
    sequence(:login_id, 3) { |i| "test_user#{ i }" }
    sequence(:password, 3) { |i| "test_user#{ i }" }
    answer { "大元小学校" }
    is_admin { false }
    after(:create) do |user|
      File.open('public/test.jpg') do |f|
        user.image.attach(io: f, filename: "test.jpg")
      end
    end
  end

  factory :new_admin_user, class: User do
    association :secret_question, factory: :new_secret_question2
    name { "管理ユーザー１" }
    login_id { "admin_user1" }
    password { "admin_user1" }
    answer { "大元小学校" }
    is_admin { true }
    after(:create) do |user|
      File.open('public/test.jpg') do |f|
        user.image.attach(io: f, filename: "test.jpg")
      end
    end
  end

  # login_idとpasswordが固定のため新しいの作った
  # 被っちゃダメなデータは必ず必ずシーケンス使うこと
  factory :new_admin_user2, class: User do
    association :secret_question, factory: :new_secret_question2
    sequence(:name) { |i| "管理ユーザー#{ i }" }
    sequence(:login_id) { |i| "admin_user#{ i }" }
    sequence(:password) { |i| "admin_user#{ i }" }
    answer { "小学校" }
    is_admin { true }
    after(:create) do |user|
      File.open('public/test.jpg') do |f|
        user.image.attach(io: f, filename: "test.jpg")
      end
    end
  end
end
