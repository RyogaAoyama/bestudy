require 'rails_helper'
describe '利用者のアカウントを作成' do

  before do
    visit nomal_new_path
  end
  
  describe '共通の入力チェック' do

    context '特殊文字のチェック' do
      error_str = %w( , " ' . / \ = ? ! : ; )
      error_str.each do |str|
        before do
          fill_in 'name', with: str
          click_on '登録'
          puts "before2"
        end
        it { expect( page ).to have_selector '#nameError', text: '不正な文字が含まれています' }
        it '次はIDのチェックを実装します！'
      end
    end

    context '空白の場合' do
      before do
        fill_in 'name', with: '  '
        click_on '登録'
      end
      it { expect( page ).to have_selector '#nameError', text: '名前を入力してください' }
    end
  end

  describe '名前の入力チェック' do
    # エラーパターン
    context '31文字の場合' do
      before do
        fill_in 'name', with: 'あああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it { expect( page ).to have_selector '#nameError', text: '30文字以下で入力してください' }
    end

    # 正常パターン
    context '1文字の場合' do
      before do
        fill_in 'name', with: 'あ'
        click_on '登録'
      end
      it { expect( page ).not_to have_selector '#nameError', text: '30文字以下で入力してください' }
    end
    context '30文字の場合' do
      before do
        fill_in 'name', with: 'ああああああああああああああああああああああああああああああ'
        click_on '登録'
      end
      it { expect( page ).not_to have_selector '#nameError', text: '30文字以下で入力してください' }
    end
  end
end