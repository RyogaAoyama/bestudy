require 'rails_helper'

describe 'ログイン確認' do
  
  context 'ユーザー認証に成功した場合' do
    before do
      visit login_path
      fill_in 'login_id', with: user.login_id
      fill_in 'password', with: user.password
      click_on 'ログイン'
    end
    let(:user) { FactoryBot.create(:user, login_id: 'login_test1', password: 'login_test1') }

    it 'ログイン完了メッセージが表示されている' do
      expect(page).to have_content "ログインに成功しました。ようこそ、#{ user.name }さん！"
    end

    it 'ヘッダーに自分の名前が表示されている' do
      expect(page).to have_content "#{ user.name }"
    end
  end

  context 'ユーザー認証に失敗した場合' do
    before do
      visit login_path
      fill_in 'login_id', with: 'login_miss1'
      fill_in 'password', with: 'user.password'
      click_on 'ログイン'
    end
    it 'エラーメッセージが表示されている' do
      expect(page).to have_content 'ログインIDとパスワードが一致しません'
    end

    it '入力したログインIDが保持されている' do
      expect(page).to have_field 'login_id', with: 'login_miss1'
    end
  end
end