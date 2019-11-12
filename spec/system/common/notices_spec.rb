require 'rails_helper'

describe 'お知らせ機能' do
  let(:user) { FactoryBot.create(:new_nomal_user2, password: 'testuser1') }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:notice) { FactoryBot.create(:notice, :room, room_id: room.id, user_id: user.id) }

  before do
    notice
    new_login(user.login_id, 'testuser1')
  end

  it 'お知らせ項目が全て表示されている' do
    find("#notice").click
    expect(page).to have_content notice.created_at.strftime('%Y/%m/%d %H:%M')
    # TODO: デコレーターを使う想定
    expect(page).to have_content notice_disp(notice.type)
  end

  context 'お知らせがない場合' do
    it 'お知らせなしのメッセージを表示' do
      find("#notice").click
      expetc(page).to have_content '現在、お知らせはありません'
    end
  end

  context '新規お知らせが来た場合' do
    # TODO: 実装方法がわからんからわかったら書く
    it 'お知らせボタンに新規お知らせの件数が表示されている'
  end
end