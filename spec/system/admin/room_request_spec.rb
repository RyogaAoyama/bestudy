require 'rails_helper'

describe 'ユーザー承認機能' do
  let(:point) { FactoryBot.create(:point, user_id: nomal_user.id) }
  let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: room.id) }
  let(:room) { FactoryBot.create(:new_room) }
  let(:room_request) { FactoryBot.create(:room_request, room_id: room.id, user_id: nomal_user.id) }

  before do
    room
    new_login('admin_user1', 'admin_user1')
    room_request
    visit admin_room_requests_path
  end

  describe 'ユーザー選択' do
    context 'ユーザーが存在しない場合' do
      let(:room_request) { '' }
      it 'メッセージが表示される' do
        visit admin_room_requests_path
        expect(page).to have_content '現在リクエストは存在しません'
      end
    end

    context 'ユーザーが存在する場合' do
      it 'ユーザー一覧が表示される' do
        expect(page).to have_selector "#user-#{ nomal_user.id }"
      end
      it '一覧の項目が全て表示されている' do
        expect(page).to have_content nomal_user.name
        expect(page).to have_content room_request.created_at.strftime('%Y/%m/%d')
        # TODO:これはユーザー写真登録ができてから
        # expect(find("#img-#{ nomal_user.id }")[:src]).to match 'public/test.jpg'
      end
    end
  end

  describe '承認・拒否' do
    let(:selection) { click_on '承認' }
    subject(:belong_room) { RoomRequest.find_by(user_id: nomal_user.id) }
    before do
      click_on "user-#{ nomal_user.id }"
      selection
    end
    context '承認' do
      it 'ユーザーテーブルにルーム情報を保存する' do
        is_expected.to be_nil
        expect(User.find(nomal_user.id).room_id).to eq room.id
        expect(current_path).to eq admin_room_requests_path
        expect(page).to have_content "#{ nomal_user.name }を承認しました"
      end
      # TODO:お知らせ機能実装時に
      it 'ユーザーにお知らせする'
    end

    context '拒否' do
      let(:selection) { click_on '拒否' }
      it 'ルームリクエストから削除する' do
        is_expected.to be_nil
        expect(current_path).to eq admin_room_requests_path
        expect(page).to have_content "#{ nomal_user.name }を拒否しました"
      end
    end
  end
end
