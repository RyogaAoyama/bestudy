require 'rails_helper'

describe 'テスト入力機能' do
  let(:point) { FactoryBot.create(:point, user_id: nomal_user.id, room_id: room.id) }
  let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: room.id) }
  let(:room) { FactoryBot.create(:new_room) }
  let(:curriculums) { 6.times.map { FactoryBot.create(:curriculum_sequence, room_id: room.id) } }

  before do
    room
    new_login('admin_user1', 'admin_user1')
  end

  describe 'ユーザー選択' do
    context 'ユーザーが存在しない場合' do
      it 'ユーザーが存在しない旨のメッセージが表示される' do
        visit admin_test_results_path
        expect(page).to have_content '現在ルームに所属しているユーザーはいません'
      end
    end

    context 'ユーザーが存在する場合' do
      it 'ユーザー一覧の項目が全て表示されている' do
        nomal_user
        visit admin_test_results_path
        expect(page).to have_content nomal_user.name
        # TODO:これはユーザー写真登録ができてから
        # expect(find("#img-#{ nomal_user.id }")[:src]).to match 'public/test.jpg'
      end
    end
  end

  describe 'テスト入力' do
    context '科目' do
      it '登録されている科目が全て表示されている' do
        curriculums
        nomal_user
        point
        visit admin_test_results_path
        click_on "user-#{ nomal_user.id }"
        curriculums.each do |curriculum|
          expect(page).to have_content curriculum
        end
      end
    end
  end

  describe '登録確認' do
    it '確認モーダルが表示される' do
      curriculums
      nomal_user
      point
      visit admin_test_results_path
      click_on "user-#{ nomal_user.id }"
      select '科目２', from: '科目'
      fill_in 'test', with: 100
      click_on '登録'
      expect(page).to have_selector '#modal'
    end
  end

  describe 'テスト登録' do
    let(:in_test) { fill_in 'test', with: 100 }
    before do
      curriculums
      nomal_user
      point
      visit admin_test_results_path
      click_on "user-#{ nomal_user.id }"
      select '科目２', from: '科目'
      in_test
      click_on '登録'
    end

    context 'エラー' do
      let(:in_test) { fill_in 'test', with: ' ' }
      # TODO: 単体テストにバリデーション追加
      it 'エラーが表示される' do
        expect(page).to have_content '点数を入力してください'
      end
    end
    
    context '正常' do
      context '全角数字の場合' do
        let(:in_test) { fill_in 'test', with: '１００' }
        it '正しくポイントが加算される' do
          expect(TestResult.find_by(user_id: nomal_user.id).score).to eq 100
          expect(Point.find_by(user_id: nomal_user.id).point).to eq 100
          expect(current_path).to eq admin_test_results_path
          expect(page).to have_content 'テストの登録が完了しました'
        end
      end
    end
  end
end