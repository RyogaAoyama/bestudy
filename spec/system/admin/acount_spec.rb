# frozen_string_literal: true
require 'rails_helper'

describe '管理者のアカウントを作成' do
  before do
    visit new_admin_acount_path
    fill_in 'name', with: 'MH'
    fill_in 'login_id', with: 'test_user1'
    fill_in 'password', with: 'test_user1'
    fill_in 'password_confirmation', with: 'test_user1'
    fill_in 'answer', with: 'MIHO'
    click_on '次へ'
    fill_in 'name', with: 'Ruby勉強会'
    fill_in 'regist_id', with: 'testtest'
    click_on '登録'
  end
  it '登録完了メッセージが表示されている' do
    expect(page).to have_contect '登録が完了しました。ようこそ！MHさん！'
  end
end

describe '入力フォームのエラーメッセージが表示される' do
  describe 'ユーザー情報入力のエラーメッセージ' do
    before do
      visit new_admin_acount_path
      fill_in 'name', with: ''
      fill_in 'login_id', with: ''
      fill_in 'password', with: ''
      fill_in 'password_confirmation', with: ''
      fill_in 'answer', with: ''
      click_on '次へ'
    end
    it '【名前】エラーメッセージが表示される' do
      expect(page).to have_content '名前を入力してください'
    end
    it '【ログインID】エラーメッセージが表示される' do
      expect(page).to have_content 'ログインIDを入力してください'
    end
    it '【パスワード】エラーメッセージが表示される' do
      expect(page).to have_content 'パスワードを入力してください'
    end
    it '【確認】エラーメッセージが表示される' do
      expect(page).to have_content '確認とパスワードの入力が一致しません'
    end
    it '【秘密の質問の回答】エラーメッセージが表示される' do
      expect(page).to have_content '回答を入力してください'
    end
  end

  describe 'グループ情報入力のエラーメッセージ' do
    before do
      visit new_admin_acount_path
      fill_in 'name', with: 'MH'
      fill_in 'login_id', with: 'test_user1'
      fill_in 'password', with: 'test_user1'
      fill_in 'password_confirmation', with: 'test_user1'
      fill_in 'answer', with: 'MIHO'
      click_on '次へ'
      fill_in 'name', with: ''
      fill_in 'regist_id', with: ''
      click_on '登録'
    end

    it '【グループID】エラーメッセージが表示される' do
      expect(page).to have_content 'グループIDを入力してください'
    end
    it '【グループ名】エラーメッセージが表示される' do
      expect(page).to have_content 'グループ名を入力してください'
    end
  end
end
