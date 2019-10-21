# frozen_string_literal: true
require 'rails_helper'

describe '利用者のアカウントを作成' do
  before do
    FactoryBot.create(:secret_question)
    visit nomal_new_path
  end

  context '登録完了' do
    before do
      fill_in 'name', with: "ゆーざー１"
      fill_in 'login_id', with: "testuser1"
      fill_in 'password', with: "testuser1"
      fill_in 'password_confirmation', with: 'testuser1'
      fill_in 'answer', with: "秘密や"
      click_on '登録'
    end

    it '登録完了メッセージが表示される' do
      expect(page).to have_content '登録が完了しました。ようこそ！ゆーざー１さん！'
    end
    it 'ユーザーレコードが作成されている' do
      expect(User.find_by(login_id: 'testuser1')).to be_present
    end
    it 'ポイントレコードが作成されている' do
      user = User.find_by(login_id: 'testuser1')
      expect(Point.find_by(user_id: user.id)).to be_present
    end
  end

  shared_examples 'エラーメッセージが表示されている' do |msg|
    it { expect(page).to have_content msg }
  end

  shared_examples 'エラーなく正常に動作している' do |msg|
    it { expect(page).not_to have_content msg }
  end
  describe '入力フォームのエラーチェック' do
    describe '特殊文字チェック' do
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

        # パスワード
        it 'パスワードの特殊文字チェック' do
          fill_in 'password', with: "aaaaa#{str}aaa1"
          click_on '登録'
          expect(page).to have_content 'パスワードに不正な文字が含まれています'
        end

        # 秘密の質問の回答
        it '秘密の質問の特殊文字チェック' do
          fill_in 'answer', with: "aaaaa#{str}aaa1"
          click_on '登録'
          expect(page).to have_content '回答に不正な文字が含まれています'
        end
      end
    end

    describe '空白チェック' do
      before do
        fill_in key, with: value
        click_on '登録'
      end
      let(:key) { 'name' }
      let(:value) { '  ' }
      it_behaves_like 'エラーメッセージが表示されている', '名前を入力してください'
      # ログインID
      let(:key) { 'login_id' }
      let(:value) { '  ' }
      it_behaves_like 'エラーメッセージが表示されている', 'ログインIDを入力してください'

      # パスワード
      let(:key) { 'password' }
      let(:value) { '  ' }
      it_behaves_like 'エラーメッセージが表示されている', 'パスワードを入力してください'

      # 秘密の質問の回答
      let(:key) { 'answer' }
      let(:value) { '  ' }
      it_behaves_like 'エラーメッセージが表示されている', '回答を入力してください'
    end

    describe '文字数チェック' do
      before do
        fill_in key, with: value
        click_on '登録'
      end
      # 名前
      # 異常パターン
      context '31文字の場合' do
        let(:key) { 'name' }
        let(:value) { 'あああああああああああああああああああああああああああああああ' }

        it_behaves_like 'エラーメッセージが表示されている', '名前は30文字以内で入力してください'
      end

      # 正常パターン
      context '1文字の場合' do
        let(:key) { 'name' }
        let(:value) { 'あ' }
        it_behaves_like 'エラーなく正常に動作している', '名前は30文字以内で入力してください'
      end

      context '30文字の場合' do
        let(:key) { 'name' }
        let(:value) { 'ああああああああああああああああああああああああああああああ' }
        it_behaves_like 'エラーなく正常に動作している', '名前は30文字以内で入力してください'
      end
      # ログインID
      # 異常パターン
      context '7文字以上の場合' do
        let(:key) { 'login_id' }
        let(:value) { 'aa' }
        it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
      end
      context '30文字の場合' do
        let(:key) { 'login_id' }
        let(:value) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
        it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは6文字以上30文字以内で入力してください'
      end

      # 正常パターン
      context '6文字の場合' do
        let(:key) { 'login_id' }
        let(:value) { 'aaaaaa' }
        it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
      end
      context '30文字の場合' do
        let(:key) { 'login_id' }
        let(:value) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
        it_behaves_like 'エラーなく正常に動作している', 'ログインIDは6文字以上30文字以内で入力してください'
      end

      # パスワード
      #異常パターン
      context '7文字以下の場合' do
        let(:key) { 'password' }
        let(:value) { 'aa11' }
        it_behaves_like 'エラーメッセージが表示されている', 'パスワードは8文字以上40文字以内で入力してください'
      end
      context '41文字以上の場合' do
        let(:key) { 'password' }
        let(:value) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa111aaaaaaaaaaaaaaaaa' }
        it_behaves_like 'エラーメッセージが表示されている', 'パスワードは8文字以上40文字以内で入力してください'
      end

      # 正常パターン
      context '8文字の場合' do
        let(:key) { 'password' }
        let(:value) { 'aaaaaaaa' }
        it_behaves_like 'エラーなく正常に動作している', 'パスワードは8文字以上40文字以内で入力してください'
      end
      context '40文字の場合' do
        let(:key) { 'password' }
        let(:value) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11aaa' }
        it_behaves_like 'エラーなく正常に動作している', 'パスワードは8文字以上40文字以内で入力してください'
      end

      # 秘密の質問の回答
      # 異常パターン
      context '51文字の場合' do
        let(:key) { 'answer' }
        let(:value) { 'あああああああああああああああああああああああああああああああaaaaaaaaaaaaaaaaaaaa' }
        it_behaves_like 'エラーメッセージが表示されている', '回答は50文字以内で入力してください'
      end

      # 正常パターン
      context '1文字の場合' do
        let(:key) { 'answer' }
        let(:value) { 'あ' }
        it_behaves_like 'エラーなく正常に動作している', '回答は50文字以内で入力してください'
      end

      context '50文字の場合' do
        let(:key) { 'answer' }
        let(:value) { 'あああああああああああああああああああああああああああああああaaaaaaaaaaaaaaaaaaa' }
        it_behaves_like 'エラーなく正常に動作している', '回答は50文字以内で入力してください'
      end
    end

    describe '重複チェック' do
      context '重複したログインIDが登録された場合' do
        before do
          FactoryBot.create(:user)
          fill_in 'login_id', with: User.find(1).login_id
          click_on '登録'
        end
        it_behaves_like 'エラーメッセージが表示されている', 'ログインIDはすでに存在します'
      end
    end

    describe '全角入力チェック' do
      before do
        fill_in key, with: value
        click_on '登録'
      end
      context 'ログインIDに全角が入力された場合' do
        let(:key) { 'login_id' }
        let(:value) { 'あああああああああああ' }
        it_behaves_like 'エラーメッセージが表示されている', 'ログインIDは半角文字で入力してください'
      end

      context 'パスワードに全角が入力された場合' do
        let(:key) { 'password' }
        let(:value) { 'あああああああああ' }
        it_behaves_like 'エラーメッセージが表示されている', 'パスワードは半角文字で入力してください'
      end
    end

    describe '英数字が含まれるかチェック' do
      before do
        fill_in key, with: value
        click_on '登録'
      end
      # パスワード
      context '数字が含まれてない場合' do
        let(:key) { 'password' }
        let(:value) { 'aaaaaaaaa' }
        it_behaves_like 'エラーメッセージが表示されている', 'パスワードは英数字を含めてください'
      end
      context '英字が含まれていない場合' do
        let(:key) { 'password' }
        let(:value) { '1234567890' }
        it_behaves_like 'エラーメッセージが表示されている', 'パスワードは英数字を含めてください'
      end

      context '英数字が含まれている場合' do
        let(:key) { 'password' }
        let(:value) { 'aaaaaaaaa111' }
        it_behaves_like 'エラーなく正常に動作している', 'パスワードは英数字を含めてください'
      end
    end

    describe 'パスワードの入力チェック' do
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
end
