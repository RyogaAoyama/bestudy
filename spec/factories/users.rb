FactoryBot.define do
  factory :user do
    name { "MyString" }
    login_id { "MyString" }
    answer { "MyString" }
    password { "MyString" }
    is_admin { false }
  end
end
