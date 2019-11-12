require 'rails_helper'

describe 'お知らせ機能' do
  let(:user) { FactoryBot.create(:new_nomal_user2, password: 'testuser1') }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:notice) { FactoryBot.create(:notice, :room_request_ok, room_id: room.id, user_id: user.id) }

  before do
    notice
    new_login(user.login_id, 'testuser1')
    ActiveDecorator::Decorator.instance.decorate(notice)
  end

  it 'お知らせ項目が全て表示されている' do
    find('#notice').click
    expect(page).to have_content notice.created_at.strftime('%Y/%m/%d %H:%M')
    expect(page).to have_content notice.disp_notice
  end

  context 'お知らせがない場合' do
    let(:notice) { '' }
    it 'お知らせなしのメッセージを表示' do
      find('#notice').click
      expect(page).to have_content '現在、お知らせはありません'
    end
  end
end
