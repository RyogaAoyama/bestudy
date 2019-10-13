require 'rails_helper'

describe 'ログイン確認' do
  describe '管理者' do
    context 'ユーザー認証に成功した場合' do
      let(:room) { FactoryBot.create(:new_room) }
      let(:user) { User.find(room.user_id) }
      before do
        room
        visit login_path
        fill_in 'login_id', with: user.login_id
        fill_in 'password', with: 'admin_user1'
        click_on 'ログイン'
      end
  
      it 'ログイン完了メッセージが表示されている' do
        expect(page).to have_content "ログインに成功しました。ようこそ、#{ user.name }さん！"
      end
      it 'ログアウトメッセージを出力' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
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
end