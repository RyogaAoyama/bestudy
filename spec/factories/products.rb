FactoryBot.define do
  factory :product do
    name { "商品名" }
    point { 300 }
    is_deleted { false }
    after(:create) do |product|
      File.open('public/test.jpg') do |f|
        product.product_img.attach(io: f, filename: "test.jpg")
      end
    end
  end
end
