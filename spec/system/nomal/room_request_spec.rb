require 'rails_helper'

describe 'ルーム申請機能' do
  let(:user) { FactoryBot.create(:new_nomal_user, password: 'nomal_user1') }
  let(:room) { FactoryBot.create(:new_room) }
  let(:regist_id) { room.regist_id }
  let(:room_request) { '' }
  before do
    room
    new_login(user.login_id, 'nomal_user1')
    visit acount_path(user)
    room_request
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
      expect(current_path).to eq acount_path(user)
    end
    it '管理者にお知らせする' do
      expect(Notice.find_by(user_id: user.id)).to be_present
    end
  end

  context '既に他のルームに申請を出している場合' do
    let(:room_request) { FactoryBot.create(:room_request, user_id: user.id, room_id: room.id) }
    let(:admin_user) { FactoryBot.create(:new_admin_user, login_id: 'admin_test001', password: 'admin_test001') }
    let(:room2) { FactoryBot.create(:room, user_id: admin_user.id) }
    before do
      fill_in 'regist_id', with: room2.regist_id
      click_on 'ルーム申請'
      find('#modal')
    end
    it '確認モーダルが表示される' do
      expect(page).to have_selector '#modal'
      expect(page).to have_content room.name
    end
    it '申請が完了する' do
      click_on '申請'
      expect(RoomRequest.where(user_id: user.id).size).to eq 1
      expect(page).to have_content "#{ room2.name }に申請を出しました"
      expect(RoomRequest.find_by(user_id: user.id)).to be_present
      expect(current_path).to eq acount_path(user)
    end
    it '管理者にお知らせする' do
      click_on '申請'
      expect(Notice.find_by(user_id: user.id)).to be_present
    end
  end

  context 'エラー処理' do
    it 'エラーメッセージを表示する' do
      fill_in 'regist_id', with: ' '
      click_on 'ルーム申請'
      expect(page).to have_content 'ルームが存在しません'
    end
  end

end