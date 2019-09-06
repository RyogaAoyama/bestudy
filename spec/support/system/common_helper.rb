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
    SecretQuestion.all.delete_all
    User.all.delete_all
    Room.all.delete_all
  end

  def create_nomal_user
    FactoryBot.create(:secret_question2)
    FactoryBot.create(:nomal_user)
  end

  # def product_regist
  #   click_on 'plus'
  #   fill_in  'name',  with: '商品名'
  #   fill_in  'point', with: 300
  #   attach_file 'product_img', 'public/test.jpg'
  #   click_on '登録'
  # end
end