# frozen_string_literal: true
require 'rails_helper'

describe '管理者のアカウントを作成' do
  before do
    visit new_admin_acount_path
    fill_in  'name',                  with: 'MH'
    fill_in  'login_id',              with: 'test_user1'
    fill_in  'password',              with: 'test_user1'
    fill_in  'password_confirmation', with: 'test_user1'
    fill_in  'answer',                with: 'MIHO'
    click_on '次へ'
    fill_in  'room_name',             with: 'Ruby勉強会'
    fill_in  'regist_id',             with: 'testtest'
    click_on '登録'
  end
  it { expect(page).to have_content '登録が完了しました。ようこそ！MHさん！' }
end

describe '入力フォームのエラーメッセージが表示される' do
  describe 'ユーザー入力フォーム' do
    before do
      visit new_admin_acount_path
      fill_in  'name',                  with: ''
      fill_in  'login_id',              with: ''
      fill_in  'password',              with: ''
      fill_in  'password_confirmation', with: ''
      fill_in  'answer',                with: ''
      click_on '次へ'
    end
    it { expect(page).to have_content '名前を入力してください' }
    it { expect(page).to have_content 'ログインIDを入力してください' }
    it { expect(page).to have_content 'パスワードを入力してください' }
    it { expect(page).to have_content '確認とパスワードの入力が一致しません' }
    it { expect(page).to have_content '回答を入力してください' }
  end

  describe 'ルーム入力フォーム' do
    before do
      visit new_admin_acount_path
      fill_in  'name',                  with: 'MH'
      fill_in  'login_id',              with: 'test_user1'
      fill_in  'password',              with: 'test_user1'
      fill_in  'password_confirmation', with: 'test_user1'
      fill_in  'answer',                with: 'MIHO'
      click_on '次へ'
      fill_in  'room_name',             with: ''
      fill_in  'regist_id',             with: ''
      click_on '登録'
    end

    it { expect(page).to have_content 'ルームIDを入力してください' }
    it { expect(page).to have_content 'ルーム名を入力してください' }
  end
end

describe 'アカウントの編集' do
  let(:user) { User.find(1) }
  before do
    login
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
      xit '【写真】エラーメッセージが表示される' do
        attach_file "profile_img", "/tmp/test.txt"
        click_on    '保存'
        expect(page).to have_content '画像ファイルを選択してください'
      end
      it '【名前】入力した値が保持されていること' do
        fill_in 'name',                    with: 'a' * 40
        expect(page).to have_field 'name', with: 'a' * 40
      end
    end

    context '正常パターン' do
      it '登録されている名前が入力されている' do
        expect(page).to have_field 'name', with: user.name
      end
      xit '登録されている写真がアップロードされている' do
        attach_file 'profile_img', 'TODO:写真のパスはこの機能のPGしてからかく'
        # TODO: have_fieldで画像ファイルが取れるのか確認
        expect(page).to have_field 'profile_img', with: user.image
      end
      it '名前が変更されている' do
        fill_in  'name', with: '藤井'
        click_on '保存'
        expect(user.name).to eq '藤井'
      end
      xit '写真が変更されている' do
        attach_file "profile_img", "TODO:写真のパスはこの機能のPGしてからかく"
        click_on    '保存'
        expect(user.image).to eq 'TODO:写真のパスはこの機能のPGしてからかく'
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
          fill_in  'password', with: 'test_user1'
          click_on '認証'
        end
        it { expect(current_path).to eq edit_password_admin_acount_path(user) }
      end
    end

    context '変更' do
      before do
        click_on 'パスワード変更'
        fill_in  'password', with: 'test_user1'
        click_on '認証'
      end
      context 'エラーパターン' do
        before do
          fill_in  'password',              with: ' '
          fill_in  'password_confirmation', with: 'test_user1'
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

    describe '秘密の質問' do
      context '認証' do
        context 'エラーパターン' do
          it 'エラーメッセージが表示される'
          it '入力した値が保持されていること'
        end
        context '正常パターン' do
          it '秘密の質問変更画面へ遷移している'
        end
      end
      context '変更' do
        context 'エラーパターン' do
          it 'エラーメッセージが表示される'
        end
        context '正常パターン' do
          it '秘密の質問が変更されている'
          it 'アカウント詳細画面に遷移している'
          it '秘密の質問変更完了のメッセージが出力されている'
        end
      end
    end
  end
end
