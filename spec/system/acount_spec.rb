require 'rails_helper'
describe '利用者のアカウントを作成' do

  before do
    visit nomal_new_path
  end
  
  describe '共通の入力チェック' do

    context '特殊文字のチェック' do
      error_str = %w( , " ' . / \ = ? ! : ; )
      error_str.each do |str|
        it do
          fill_in 'name', with: "あああ#{str}あ"
          click_on '登録'
          expect( page ).to have_content '名前に不正な文字が含まれています'
        end
        it '次はIDのチェックを実装します！'
      end
    end

    context '空白の場合' do
      before do
        fill_in 'name', with: '  '
        click_on '登録'
      end
      it { expect( page ).to have_content '名前を入力してください' }
    end
  end

  describe '名前の入力チェック' do
    # エラーパターン
    context '31文字の場合' do
      before do
        fill_in 'name', with: 'あああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it { expect( page ).to have_content '名前は30文字以内で入力してください' }
    end

    # 正常パターン
    context '1文字の場合' do
      before do
        fill_in 'name', with: 'あ'
        click_on '登録'
      end
      it { expect( page ).not_to have_content '名前は30文字以内で入力してください' }
    end
    context '30文字の場合' do
      before do
        fill_in 'name', with: 'ああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it { expect( page ).not_to have_content '名前は30文字以内で入力してください' }
    end
  end
end