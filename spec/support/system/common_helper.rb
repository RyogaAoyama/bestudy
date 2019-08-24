# 全機能共通ヘルパー
module CommonHelper
  def login
    FactoryBot.create(:secret_question)
    user = FactoryBot.create(:user)
    visit login_path
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.password
    click_on 'ログイン'
    p "ログイン成功"
  end
end