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
    context '特殊文字が入力された場合' do
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
        # ログインID
        it 'パスワードの特殊文字チェック' do
          fill_in 'password', with: "aaaaa#{str}aaa1"
          click_on '登録'
          expect(page).to have_content 'パスワードに不正な文字が含まれています'
        end
      end
    end

    context '空白の場合' do
      # 名前
      before do
        fill_in 'name', with: '  '
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', '名前を入力してください'
      # ログインID
      before do
        fill_in 'login_id', with: '  '
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDを入力してください'

      # パスワード
      before do
        fill_in 'password', with: '  '
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードを入力してください'
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
    context '7文字以上の場合' do
      before do
        fill_in 'login_id', with: 'aa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
    end
    context '30文字の場合' do
      before do
        fill_in 'login_id', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
    end

    # 正常パターン
    context '6文字の場合' do
      before do
        fill_in 'login_id', with: 'aaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
    end
    context '30文字の場合' do
      before do
        fill_in 'login_id', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
    end

    context '全角が入力された場合' do
      before do
        fill_in 'login_id', with: 'あああああああああ'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは半角文字で入力してください'
    end

    context '重複したログインIDが登録された場合' do
      before do
        FactoryBot.create(:secret_question)
        FactoryBot.create(:user)
        fill_in 'login_id', with: User.find(1).login_id
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDはすでに存在します'
    end
  end

  describe 'パスワードの入力チェック' do
    context '全角が入力された場合' do
      before do
        fill_in 'password', with: 'あああああああああ'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードは半角文字で入力してください'
    end

    #異常パターン
    context '7文字以下の場合' do
      before do
        fill_in 'password', with: 'aa11'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードは8文字以上40文字以内で入力してください'
    end
    context '41文字以上の場合' do
      before do
        fill_in 'password', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa111aaaaaaaaaaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードは8文字以上40文字以内で入力してください'
    end

    # 正常パターン
    context '8文字の場合' do
      before do
        fill_in 'password', with: 'aaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'パスワードは8文字以上40文字以内で入力してください'
    end
    context '40文字の場合' do
      before do
        fill_in 'password', with: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11aaa'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'パスワードは8文字以上40文字以内で入力してください'
    end

    context '数字が含まれてない場合' do
      before do
        fill_in 'password', with: 'aaaaaaaaa'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードは英数字を含めてください'
    end
    context '英字が含まれていない場合' do
      before do
        fill_in 'password', with: '1234567890'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードは英数字を含めてください'
    end

    context '英数字が含まれている場合' do
      before do
        fill_in 'password', with: 'aaaaaaaaa111'
        click_on '登録'
      end
      it_behaves_like 'エラーなく正常に動作している', 'パスワードは英数字を含めてください'
    end

    context '確認で異なるパスワードが入力された時' do
      before do
        fill_in 'password', with: 'aaaaaaa11'
        fill_in 'password_confirmation', with: 'aaaaaaa22'
        click_on '登録'
      end
      it_behaves_like 'エラーメッセージが表示されている', '確認とパスワードの入力が一致しません'
    end
  end
end
