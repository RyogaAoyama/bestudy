FactoryBot.define do
  factory :product do
    id { 1 }
    name { "商品名" }
    point { 300 }
    is_deleted { false }
    user_id { 1 }
    after(:create) do |product|
      File.open('public/test.jpg') do |f|
        product.product_img.attach(io: f, filename: "test.jpg")
      end
    end
  end
end
