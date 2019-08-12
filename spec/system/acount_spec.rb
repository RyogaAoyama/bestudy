# frozen_string_literal: true
require 'rails_helper'

describe '利用者のアカウントを作成' do
  before do
    visit nomal_new_path
  end

  shared_examples 'エラーメッセージが表示されている' do |msg|
    it { expect(page).to have_content msg }
  end

  shared_examples 'エラーなく正常に動作している' do |msg|
    it { expect(page).not_to have_content msg }
  end

  describe '共通の入力チェック' do
    context '特殊文字のチェック' do
      error_str = %w[, " ' . / \ = ? ! : ;]
      error_str.each do |str|
        # 名前
        it '名前の特殊文字チェック' do
          fill_in 'name', with: "あああ#{str}あ"
          click_on '登録'
          expect(page).to have_content '名前に不正な文字が含まれています'
        end
        # ログインID
        it 'ログインIDの特殊文字チェック' do
          fill_in 'login_id', with: "aaaaa#{str}aaa"
          click_on '登録'
          expect(page).to have_content 'ログインIDに不正な文字が含まれています'
        end
      end
    end

    context '空白の場合' do
      before do
        fill_in 'name', with: '  '
        click_on '登録'
      end
      # 名前
      it_behaves_like 'エラーメッセージが表示されている', '名前を入力してください'
      # ログインID
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDを入力してください'
    end
  end

  describe '名前の入力チェック' do
    # 異常パターン
    context '31文字の場合' do
      before do
        fill_in 'name', with: 'あああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', '名前は30文字以内で入力してください'
    end

    # 正常パターン
    context '1文字の場合' do
      before do
        fill_in 'name', with: 'あ'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', '名前は30文字以内で入力してください'
    end

    context '30文字の場合' do
      before do
        fill_in 'name', with: 'ああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', '名前は30文字以内で入力してください'
    end
  end

  describe 'ログインIDの入力チェック' do
    #異常パターン
    context '6文字以上' do
      before do
        fill_in 'login_id', with: 'aa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
    end
    context '30文字以内' do
      before do
        fill_in 'login_id', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
    end

    # 正常パターン
    context '6文字' do
      before do
        fill_in 'login_id', with: 'aaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
    end
    context '30文字' do
      before do
        fill_in 'login_id', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
    end

    context '全角入力禁止' do
      before do
        fill_in 'login_id', with: 'あああああああああ'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは半角文字で入力してください'
    end

    context '重複チェック' do
      before do
        FactoryBot.create(:secret_question)
        FactoryBot.create(:user)
        fill_in 'login_id', with: User.find(1).login_id
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDはすでに存在します'
    end
  end
end
