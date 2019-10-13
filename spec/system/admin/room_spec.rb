require 'rails_helper'

describe 'ルーム編集' do
  let(:user) { User.find(1) }
  before do
    login
    click_on 'user_name'
    click_on 'ルーム編集'
    click_on 'ルーム名編集'
  end
  context 'エラーパターン' do
    it 'エラーメッセージが表示される' do
      fill_in  'room_name', with: ' '
      click_on '変更'
      expect(page).to have_content 'ルーム名を入力してください'
    end
  end

  context '正常パターン' do
    it '変更完了メッセージが出力される' do
      fill_in  'room_name', with: '桑田中学校'
      click_on '変更'
      expect(page).to have_content '編集内容を保存しました'
    end
    it '変更後アカウント詳細画面に遷移する' do
      fill_in  'room_name', with: '桑田中学校'
      click_on '変更'
      expect(current_path).to eq admin_room_path(user)
    end
    it '登録されている値が保持されていること' do
      expect(page).to have_field 'room_name', with: 'test_room'
    end
  end
end