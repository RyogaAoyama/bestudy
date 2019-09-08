# 全機能共通ヘルパー
module CommonHelper
  def login
    FactoryBot.create(:secret_question)
    user = FactoryBot.create(:user)
    FactoryBot.create(:room)
    visit login_path
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.password
    click_on 'ログイン'
    p "ログイン成功"
  end

  def clear
    ProductRequest.all.delete_all
    Product.all.delete_all
    Room.all.delete_all
    User.all.delete_all
    SecretQuestion.all.delete_all
  end

  def create_nomal_user
    FactoryBot.create(:secret_question2)
    FactoryBot.create(:nomal_user)
  end

  def create_product_request
    FactoryBot.create(:secret_question2)
    user = FactoryBot.create(:nomal_user)
    product = FactoryBot.create(:product, user_id: user.id)
    FactoryBot.create(:product_request, user_id: user.id, product_id: product.id)
  end

  # def product_regist
  #   click_on 'plus'
  #   fill_in  'name',  with: '商品名'
  #   fill_in  'point', with: 300
  #   attach_file 'product_img', 'public/test.jpg'
  #   click_on '登録'
  # end
end