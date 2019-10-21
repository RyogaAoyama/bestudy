require 'rails_helper'

describe 'ルーム申請機能' do
  let(:user) { FactoryBot.create(:new_nomal_user, password: 'nomal_user1') }
  let(:room) { FactoryBot.create(:new_room) }
  let(:regist_id) { room.regist_id }
  before do
    room
    new_login(user.login_id, 'nomal_user1')
    acount_path(user)
    click_on 'ルーム申請'
    fill_in 'regist_id', with: regist_id
  end

  context '新規で申請する場合' do
    before do
      click_on 'ルーム申請'
    end
    it '申請が完了する' do
      expect(page).to have_content "#{ room.name }に申請を出しました"
      expect(RoomRequest.find_by(user_id: user.id)).to be_present
      expect(current_user).to acount_path(user)
    end
    it '管理者にお知らせする' do
      expect(Notice.find_by(user_id: user.id)).to be_present
    end
  end

  context '既に他のルームに申請を出している場合' do
    before do
      FactoryBot.create(:room_request, user_id: user.id)
      click_on 'ルーム申請'
      click_on 'ルーム申請'
    end
    it '確認モーダルが表示される' do
      expect(page).to have_selector '#modal'
    end
    it '申請が完了する' do
      expect(RoomRequest.where(user_id: user.id).size).to eq 1
      expect(page).to have_content "#{ room.name }に申請を出しました"
      expect(RoomRequest.find_by(user_id: user.name)).to be_present
      expect(current_user).to acount_path(user)
    end
    it '管理者にお知らせする' do
      expect(Notice.find_by(user_id: user.id)).to be_present
    end
  end

  context 'エラー処理' do
    it 'エラーメッセージを表示する' do
      expect(page).to have_content 'ルームIDを入力してください'
    end
  end

end