require 'rails_helper'

describe 'ポイント機能' do
  let(:room) { FactoryBot.create(:new_room2) }
  let(:admin) { User.find(room.user_id) }
  let(:user) { FactoryBot.create(:new_nomal_user, room_id: room.id, password: 'testuser1') }
  let(:point) { FactoryBot.create(:point, user_id: user.id) }
  let(:point_notice) { FactoryBot.create(:point_notice, room_id: room.id, user_id: user.id) }

  before do
    room
    point
    point_notice
    new_login(user.login_id, 'testuser1')
    click_on 'ポイント'
  end

  describe '一覧' do
    it '項目が全て表示されている' do
      expect(page).to have_content admin.name
      expect(page).to have_content point_notice.created_at.strftime('%Y/%m/%d %H:%M')
      expect(page).to have_content "#{ point_notice.get_point }pt"
    end

    context '一覧がない場合' do
      let(:point_notice) { '' }
      it 'メッセージが表示される' do
        expect(page).to have_content '現在、ポイントの付与はありません。'
      end
    end
  end

  describe '詳細' do
    before do
      click_on "point-notice-#{ point_notice.id }"
    end

    it '項目が表示されている' do
      expect(page).to have_content '付与理由'
      expect(page).to have_content "#{ admin.name }から#{ point_notice.get_point }pt付与されました。"
      expect(page).to have_content point_notice.detail
      expect(page).to have_content point_notice.created_at.strftime('%Y/%m/%d %H:%M')
    end

    context '特別ポイントの場合' do
      let(:special_point) { FactoryBot.create(:special_point, message: 'がんばった', room_id: room.id, user_id: user.id) }
      let(:point_notice) do
        FactoryBot.create(:point_notice,
                          room_id: room.id,
                          user_id: user.id,
                          special_point_id: special_point.id)
      end

      it 'メッセージが表示されている' do
        expect(page).to have_content 'ルームからのメッセージ'
        expect(page).to have_content special_point.message
      end
    end

    context '特別ポイントではない場合' do
      it 'メッセージが表示されていない' do
        expect(page).to_not have_content 'ルームからのメッセージ'
      end
    end
  end
end
