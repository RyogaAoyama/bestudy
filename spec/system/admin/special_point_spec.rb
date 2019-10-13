require 'rails_helper'

describe '特別ポイント機能' do
  let(:point) { FactoryBot.create(:point, user_id: nomal_user.id) }
  let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: room.id) }
  let(:room) { FactoryBot.create(:new_room) }

  before do
    room
    new_login('admin_user1', 'admin_user1')
    nomal_user
    visit admin_special_points_path
  end

  describe 'ユーザー一覧' do
    context 'ユーザーが存在しない場合' do
      let(:nomal_user) { '' }
      it 'ユーザーが存在しない旨を表示する' do
        expect(page).to have_content '現在ルームに所属しているユーザーはいません'
      end
    end

    context 'ユーザーが存在する場合' do
      it 'ユーザー一覧の項目が全て表示されている' do
        expect(page).to have_content nomal_user.name
        expect(find("#img-#{ nomal_user.id }")[:src]).to match(/test.jpg/)
      end
    end
  end

  describe '登録確認' do
    it '確認モーダルが表示される' do
      point
      click_on "user-#{ nomal_user.id }"
      fill_in 'point', with: 100
      fill_in 'message', with: 'いつも頑張っていますね!えくせれんと'
      click_on '登録'
      expect(page).to have_selector '#modal'
    end
  end

  describe 'テスト登録' do
    let(:in_point) { fill_in 'point', with: 100 }
    let(:in_message) { fill_in 'message', with: 'a' * 300 }

    before do
      point
      click_on "user-#{ nomal_user.id }"
      in_point
      in_message
      click_on '登録'
      click_on '特別ポイントを登録'
    end

    context 'エラー' do
      let(:in_point) { fill_in 'point', with: '  ' }
      let(:in_message) { fill_in 'message', with: 'a' * 301 }
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'ポイントを入力してください'
        expect(page).to have_content 'メッセージは300文字まで入力できます'
      end
    end

    context '正常' do
      it '正しくポイントが加算されている' do
        expect(SpecialPoint.find_by(user_id: nomal_user.id).point).to eq 100
        expect(Point.find_by(user_id: nomal_user.id).point).to eq 100
        expect(current_path).to eq admin_special_points_path
        expect(page).to have_content "#{ nomal_user.name }に特別ポイントを送りました"
      end

      it 'ユーザーにお知らせする' do
        expect(PointNotice.find_by(user_id: nomal_user.id)).to be_present
      end
    end
  end
end
