require 'rails_helper'

describe '商品登録' do
  before do
    login
    click_on 'plus'
  end
  context 'エラーの場合' do
    it '入力項目にエラーメッセージが表示される' do
      fill_in     'name',  with: '  '
      fill_in     'point', with: '  '
      attach_file 'img',   "TODO:写真のパスはこの機能のPGしてからかく"
      click_on    '登録'
      expect(page).to have_content '商品名を入力してください'
      expect(page).to have_content 'ポイントを入力してください'
      expect(page).to have_content '画像ファイルを選択してください'
    end
    it '値が保持されている' do
      fill_in     'name',  with: 'a' * 40
      fill_in     'point', with: 100000
      attach_file 'img',   'TODO:写真のパスはこの機能のPGしてからかく'
      click_on    '登録'
      expect(page).to have_field 'name', with: 'a' * 40
      expect(page).to have_field 'point', with: 100000
      expect(page).to have_field 'img',   with: 'TODO:写真のパスはこの機能のPGしてからかく'
    end
  end

  context '正常の場合' do
    before do
      fill_in     'name',  with: '商品名'
      fill_in     'point', with: 300
      attach_file 'img',   'TODO:写真のパスはこの機能のPGしてからかく'
    end
    it '入力項目にエラーが表示されない' do
      click_on    '登録'
      expect(page).to_not have_content '商品名を入力してください'
      expect(page).to_not have_content 'ポイントを入力してください'
      expect(page).to_not have_content '画像ファイルを選択してください'
    end

    it '商品一覧画面に遷移していること' do
      click_on '登録'
      expect(products_path).to eq current_path
    end

    it '商品登録完了メッセージが表示されること' do
      click_on '登録'
      expect(page).to have_content '商品名を登録しました'
    end

    it '登録した写真がすぐにプレビューされること' do
      expect(page).to has_field?('prev')
    end
  end

  it '登録時に全角の数字を半角に変換すること' #TODO:単体テストの全角数字保存できているこの項目でテストする
  it '登録に失敗した時のメッセージが表示される' #TODO: 単体テストで
end