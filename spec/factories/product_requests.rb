FactoryBot.define do
  factory :product_request do
    name { "商品名" }
    after(:create) do |product|
      File.open('public/test.jpg') do |f|
        product.request_img.attach(io: f, filename: "test.jpg")
      end
    end
  end
end
