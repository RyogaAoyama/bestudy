require 'rails_helper'
# describe 'ログイン時のヘッダー表示' do

#   before do
#     FactoryBot.create(:secret_question)
#     FactoryBot.create(:user, password: 'test_user1', login_id: 'test_user1')
#     visit login_path
#     fill_in 'login_id', with: 'test_user1'
#     fill_in 'password', with: 'test_user1'
#     click_on 'ログイン'
#   end
#   it 'ログアウトボタンが存在する' do
#     expect(page).to have_content 'ログアウト'
#   end
# end