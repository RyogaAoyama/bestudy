require 'rails_helper'

describe 'ルームに所属するユーザー一覧機能' do
  let(:room) { FactoryBot.create(:new_room) }
  let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: room.id) }

  before do
    room
    nomal_user
    new_login('admin_user1', 'admin_user1')
    visit admin_room_users_path
  end

  describe 'ユーザー選択' do
    context 'ユーザーが存在しない場合' do
      let(:nomal_user) { '' }
      it 'メッセージが表示される' do
        visit admin_room_users_path
        expect(page).to have_content '現在、所属しているユーザーは存在しません'
      end
    end

    context 'ユーザーが存在する場合' do
      it 'ユーザー一覧が表示される' do
        expect(page).to have_selector "#user-#{ nomal_user.id }"
      end
      it '一覧の項目が全て表示されている' do
        expect(page).to have_content nomal_user.name
        # TODO:これはユーザー写真登録ができてから
        # expect(find("#img-#{ nomal_user.id }")[:src]).to match 'public/test.jpg'
      end
      it '強制退会' do
         # 退会させたユーザーに関連するデータが削除されている
         # TODO: ポイント用のお知らせいらんくね？
        expect(nomal_user.room_id).to eq ''
        expect(Delivery.where(user_id: nomal_user.id).size).to eq 0
        expect(Good.where(user_id: nomal_user.id).size).to eq 0
        expect(Notice.where(user_id: nomal_user.id).size).to eq 0
        expect(OrderHistory.where(user_id: nomal_user.id).size).to eq 0
        #expect(PointNotice.find_by(user_id: nomal_user.id).point).to eq 0
        expect(Point.find_by(user_id: nomal_user.id).total_point).to eq 0
        expect(Point.find_by(user_id: nomal_user.id).room_id).to eq ''
        expect(Point.where(user_id: nomal_user.id).size).to eq 0
        expect(ProductRequest.where(user_id: nomal_user.id).size).to eq 0
        expect(Result.where(user_id: nomal_user.id).size).to eq 0
        expect(SpecialPoint.where(user_id: nomal_user.id).size).to eq 0
        expect(TestResult.where(user_id: nomal_user.id).size).to eq 0
        # 退会完了メッセージが出力されている
        expect(page).to have_content "#{ nomal_user.name }をルームから退会させました"
        # ユーザー一覧に遷移している
        expect(current_path).to eqadmin_room_users_path
      end
    end
  end
end