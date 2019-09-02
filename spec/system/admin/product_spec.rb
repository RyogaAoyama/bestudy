require 'rails_helper'

describe '商品登録' do
  before do
    login
    click_on 'plus'
  end
  context 'エラーの場合' do
    before do
      fill_in     'name',  with: 'a' * 40
      fill_in     'point', with: 100000
      attach_file 'product_img', 'public/test.txt'
      click_on    '登録'
    end
    it '入力項目にエラーメッセージが表示される' do
      expect(page).to have_content 'は30文字以内で入力してください'
      expect(page).to have_content 'は1~99999ポイントまでです'
      expect(page).to have_content 'は画像ファイルのみ対応しています'
    end
    it '値が保持される' do
      expect(page).to have_field 'name',  with: 'a' * 40
      expect(page).to have_field 'point', with: 100000
    end
  end

  context '正常の場合' do
    before do
      fill_in     'name',  with: '商品名'
      fill_in     'point', with: 300
      attach_file 'product_img', 'public/test.jpg'
    end
    it '入力項目にエラーが表示されない' do
      click_on '登録'
      expect(page).to_not have_content '商品名を入力してください'
      expect(page).to_not have_content 'ポイントを入力してください'
      expect(page).to_not have_content 'は画像ファイルのみ対応しています'
    end

    it '商品一覧画面に登録完了メッセージが表示される' do
      click_on '登録'
      expect(admin_products_path).to eq current_path
      expect(page).to have_content '「商品名」を登録しました'
    end

    it '登録した写真がプレビューされる' do
      expect(find('#prev')[:src].present?).to eq true
    end
  end
end

describe '商品一覧' do
  before do
    login
    click_on 'plus'
    fill_in  'name',  with: '商品名'
    fill_in  'point', with: 300
  end

  it '登録した商品が表示されている' do
    attach_file 'product_img', 'public/test.jpg'
    click_on    '登録'
    expect(page).to have_content '商品名'
    expect(page).to have_content '300'
    expect(find('.product_img')[:src]).to match(/test.jpg/)
  end
  it 'デフォルト画像が挿入されている' do
    click_on '登録'
    expect(find('.product_img')[:src]).to match(/default.jpg/)
  end
end