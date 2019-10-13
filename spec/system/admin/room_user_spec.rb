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
        expect(page).to have_content '現在ルームに所属しているユーザーはいません'
      end
    end

    context 'ユーザーが存在する場合' do
      let(:point) { FactoryBot.create(:point, user_id: nomal_user.id, point: 10, total: 10) }
      let(:curriculum) { FactoryBot.create(:curriculum, room_id: room.id) }
      let(:all_data) do
        2.times do
          product = FactoryBot.create(:new_product, room_id: room.id, user_id: room.user_id)
          order = FactoryBot.create(:order_history, room_id: room.id, user_id: nomal_user.id, product_id: product.id)
          special = FactoryBot.create(:special_point, room_id: room.id, user_id: nomal_user.id)
          FactoryBot.create(:delivery, room_id: room.id, product_id: product.id, user_id: nomal_user.id, order_history_id: order.id)
          FactoryBot.create(:good, user_id: nomal_user.id, product_id: product.id)
          FactoryBot.create(:notice, user_id: nomal_user.id, room_id: room.id)
          FactoryBot.create(:point_notice, room_id: room.id, user_id: nomal_user.id, special_point_id: special.id)
          FactoryBot.create(:product_request, product_id: product.id, user_id: nomal_user.id)
          FactoryBot.create(:result, curriculum_id: curriculum.id, user_id: nomal_user.id, room_id: room.id)
          FactoryBot.create(:test_result, curriculum_id: curriculum.id, user_id: nomal_user.id, room_id: room.id)
        end
      end
      it 'ユーザー一覧が表示される' do
        expect(page).to have_selector "#user-#{ nomal_user.id }"
      end
      it '一覧の項目が全て表示されている' do
        expect(page).to have_content nomal_user.name
        expect(find("#img-#{ nomal_user.id }")[:src]).to match(/test.jpg/)
      end
      it '強制退会' do
        point
        all_data
        click_on '退会'
        find('#modal')
        click_on '強制退会'
        # 退会させたユーザーに関連するデータが削除されている
        expect(User.find(nomal_user.id).room_id).to eq nil
        expect(Delivery.where(user_id: nomal_user.id).size).to eq 0
        expect(Good.where(user_id: nomal_user.id).size).to eq 0
        expect(Notice.where(user_id: nomal_user.id).size).to eq 0
        expect(OrderHistory.where(user_id: nomal_user.id).size).to eq 0
        expect(PointNotice.where(user_id: nomal_user.id).size).to eq 0
        expect(Point.find_by(user_id: nomal_user.id).total).to eq 0
        expect(Point.find_by(user_id: nomal_user.id).point).to eq 0
        expect(ProductRequest.where(user_id: nomal_user.id).size).to eq 0
        expect(Result.where(user_id: nomal_user.id).size).to eq 0
        expect(SpecialPoint.where(user_id: nomal_user.id).size).to eq 0
        expect(TestResult.where(user_id: nomal_user.id).size).to eq 0
        # 退会完了メッセージが出力されている
        expect(page).to have_content "#{ nomal_user.name }をルームから退会させました"
        # ユーザー一覧に遷移している
        expect(current_path).to eq admin_room_users_path
      end
    end
  end
end
