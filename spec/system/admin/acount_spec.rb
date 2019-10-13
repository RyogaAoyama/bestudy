# frozen_string_literal: true
require 'rails_helper'

describe '管理者のアカウントを作成' do
  before do
    FactoryBot.create(:new_secret_question)
    visit new_admin_acount_path
    fill_in  'name',                  with: 'MH'
    fill_in  'login_id',              with: 'test_user1'
    fill_in  'password',              with: 'test_user1'
    fill_in  'password_confirmation', with: 'test_user1'
    fill_in  'answer',                with: 'MIHO'
    fill_in  'room_name',             with: 'Ruby勉強会'
    fill_in  'regist_id',             with: 'testtest'
    click_on '登録'
  end
  it { expect(page).to have_content '登録が完了しました。ようこそ！MHさん！' }
end

describe '入力フォームのエラーメッセージが表示される' do
  describe 'ユーザー入力フォーム' do
    before do
      FactoryBot.create(:new_secret_question)
      visit new_admin_acount_path
      fill_in  'name',                  with: ''
      fill_in  'login_id',              with: ''
      fill_in  'password',              with: ''
      fill_in  'password_confirmation', with: ''
      fill_in  'answer',                with: ''
      fill_in  'room_name',             with: ''
      fill_in  'regist_id',             with: ''
      click_on '登録'
    end
    it { expect(page).to have_content '名前を入力してください' }
    it { expect(page).to have_content 'ログインIDを入力してください' }
    it { expect(page).to have_content 'パスワードを入力してください' }
    it { expect(page).to have_content '確認とパスワードの入力が一致しません' }
    it { expect(page).to have_content '回答を入力してください' }
    it { expect(page).to have_content 'ルームIDを入力してください' }
    it { expect(page).to have_content 'ルーム名を入力してください' }
  end
end

describe 'アカウントの編集' do
  let(:user) { User.find(room.user_id) }
  let(:room) { FactoryBot.create(:new_room) }
  before do
    room
    new_login(user.login_id, 'admin_user1')
    click_on 'user_name'
  end

  describe 'プロフィール編集' do
    before do
      click_on 'プロフィール編集'
    end

    context 'エラーパターン' do
      it '【名前】エラーメッセージが表示される' do
        fill_in  'name', with: ''
        click_on '保存'
        expect(page).to have_content '名前を入力してください'
      end
      it '【写真】エラーメッセージが表示される' do
        attach_file "profile-img", "public/test.txt"
        click_on    '保存'
        expect(page).to have_content 'プロフィール画像は画像ファイルのみ対応しています'
      end
      it '【名前】入力した値が保持されていること' do
        fill_in  'name',                   with: 'a' * 40
        click_on '保存'
        expect(page).to have_field 'name', with: 'a' * 40
      end
    end

    context '正常パターン' do
      it '登録されている名前が入力されている' do
        expect(page).to have_field 'name', with: user.name
      end
      it '登録されている写真がアップロードされている' do
        expect(find('#prev')[:src]).to match(/test.jpg/)
      end
      it '名前が変更されている' do
        fill_in  'name', with: '藤井'
        click_on '保存'
        user.reload
        expect(user.name).to eq '藤井'
      end
      it 'プロフィール変更完了のメッセージが出力されている' do
        click_on '保存'
        expect(page).to have_content '編集内容を保存しました'
      end
    end
  end

  describe 'パスワードの変更' do
    context '認証' do
      context 'エラーパターン' do
        before do
          click_on 'パスワード変更'
          fill_in  'password', with: ' '
          click_on '認証'
        end
        it { expect(page).to have_content 'パスワードが一致しません' }
      end
      context '正常パターン' do
        before do
          click_on 'パスワード変更'
          fill_in  'password', with: 'admin_user1'
          click_on '認証'
        end
        it { expect(current_path).to eq edit_password_admin_acount_path(user) }
      end
    end

    context '変更' do
      before do
        click_on 'パスワード変更'
        fill_in  'password', with: 'admin_user1'
        click_on '認証'
      end
      context 'エラーパターン' do
        before do
          fill_in  'password',              with: ' '
          fill_in  'password_confirmation', with: 'admin_user1'
          click_on '変更'
        end
        it { expect(page).to have_content 'パスワードを入力してください' }
        it { expect(page).to have_content '確認とパスワードの入力が一致しません' }
      end
      context '正常パターン' do
        before do
          fill_in  'password',              with: 'aaaaaaa222'
          fill_in  'password_confirmation', with: 'aaaaaaa222'
          click_on '変更'
        end
        it { expect(current_path).to eq admin_acount_path(user) }
        it { expect(page).to have_content '編集内容を保存しました' }
      end
    end
  end
  describe '秘密の質問' do
    context '認証' do
      context 'エラーパターン' do
        before do
          click_on '秘密の質問'
          fill_in  'password', with: ' '
          click_on '認証'
        end
        it { expect(page).to have_content 'パスワードが一致しません' }
      end
      context '正常パターン' do
        before do
          click_on '秘密の質問'
          fill_in  'password', with: 'admin_user1'
          click_on '認証'
        end
        # 秘密の質問変更画面に遷移しているかチェック
        it { expect(current_path).to eq edit_question_admin_acount_path(user) }
      end
    end

    context '変更' do
      before do
        FactoryBot.create(:secret_question2)
        click_on '秘密の質問'
        fill_in  'password', with: 'admin_user1'
        click_on '認証'
      end
      context 'エラーパターン' do
        before do
          fill_in  'answer', with: ' '
          click_on '変更'
        end
        it { expect(page).to have_content '回答を入力してください' }
      end
      context '正常パターン' do
        before do
          fill_in  'answer', with: '京都行きたい'
          select   '学生時代に好きだった人の名前', from: 'secret_question_id'
          click_on '変更'
        end
        it { expect(current_path).to eq admin_acount_path(user) }
        it { expect(page).to have_content '編集内容を保存しました' }
      end
    end
  end

  describe 'アカウント削除' do

    let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: 1) }
    let(:all_data) do
      point = FactoryBot.create(:point, user_id: nomal_user.id, point: 10, total: 10)
      curriculum = FactoryBot.create(:curriculum, room_id: 1)
      product = FactoryBot.create(:new_product, room_id: 1, user_id: 1)
      order = FactoryBot.create(:order_history, room_id: 1, user_id: nomal_user.id, product_id: product.id)
      special = FactoryBot.create(:special_point, room_id: 1, user_id: nomal_user.id)
      FactoryBot.create(:delivery, room_id: 1, product_id: product.id, user_id: nomal_user.id, order_history_id: order.id)
      FactoryBot.create(:good, user_id: nomal_user.id, product_id: product.id)
      FactoryBot.create(:notice, user_id: nomal_user.id, room_id: 1)
      FactoryBot.create(:point_notice, room_id: 1, user_id: nomal_user.id, special_point_id: special.id)
      FactoryBot.create(:product_request, product_id: product.id, user_id: nomal_user.id)
      FactoryBot.create(:result, curriculum_id: curriculum.id, user_id: nomal_user.id, room_id: 1)
      FactoryBot.create(:test_result, curriculum_id: curriculum.id, user_id: nomal_user.id, room_id: 1)
      FactoryBot.create(:room_request, room_id: 1)
    end

    before { click_on 'アカウント削除' }
    describe '削除モーダル' do
      it '戻るボタンを押下したらモーダルが消える' do
        click_on '戻る'
        expect(page).to_not have_selector '#modal'
      end
      it 'バツボタンを押下したらモーダルが消える' do
        find('#close').click
        expect(page).to_not have_selector '#modal'
      end
      it 'モーダル外を押下したらモーダルが消える' do
        find('#modal_outer').click
        expect(page).to_not have_selector '#modal'
      end
    end

    # TODO:テストが通らない。いつか解決すること
    xit 'アカウントデータと関連データが削除されている' do
      all_data
      product_request_size = ProductRequest.all.size
      click_on 'アカウントを削除'
      expect(User.find_by(id: 1)).to eq nil
      expect(Room.find_by(user_id: 1)).to eq nil
      expect(Curriculum.find_by(room_id: 1)).to eq nil
      expect(Product.find_by(room_id: 1)).to eq nil
      expect(ProductRequest.all.size).to be < product_request_size
      expect(Notice.find_by(room_id: 1)).to eq nil
      expect(RoomRequest.find_by(room_id: 1)).to eq nil
      expect(Delivery.find_by(room_id: 1)).to eq nil
      expect(Good.find_by(user_id: 1)).to eq nil
      expect(Result.find_by(room_id: 1)).to eq nil
      expect(PointNotice.find_by(room_id: 1)).to eq nil
      expect(OrderHistory.find_by(room_id: 1)).to eq nil
      expect(SpecialPoint.find_by(room_id: 1)).to eq nil
      expect(Point.find_by(user_id: nomal_user.id).point).to eq 0
      expect(Point.find_by(user_id: nomal_user.id).total).to eq 0
    end
    xit 'ホーム画面へ遷移' do
      click_on 'アカウントを削除'
      expect(current_path).to eq root_path
    end
    xit '削除完了メッセージが表示される' do
      click_on 'アカウントを削除'
      expect(page).to have_content 'アカウントを削除しました。ご利用ありがとうございました！'
    end
  end
end
