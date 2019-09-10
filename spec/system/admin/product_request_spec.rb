require 'rails_helper'

describe '一覧' do
  before do
    login
    visit admin_product_requests_path
  end
  it '商品リクエストが存在しないメッセージが表示されている' do
    create_product_request
    expect(page).to have_content '現在、商品リクエストは届いていません'
  end
  it '商品リクエストの項目が全て表示されている' do
    create_product_request
    time = Time.now
    visit admin_product_requests_path
    expect(page).to have_content '商品名'
    expect(page).to have_content 'テストユーザー2さんからのリクエスト'
    expect(page).to have_content time.strftime('%Y/%m/%d')
    expect(page).to have_content '承諾'
    expect(page).to have_content '拒否'
    expect(find('#img-1')[:src]).to match(/test.jpg/)
  end
end

describe '承諾' do
  before do
    login
    create_product_request
    visit admin_product_requests_path
  end
  context 'エラーパターン' do
    it 'エラーメッセージが表示される' do
      click_on    '承諾'
      fill_in     'name',  with: '  '
      fill_in     'point', with: '  '
      attach_file 'product_img', 'public/test.txt'
      click_on    '登録'
      expect(page).to have_content '商品名を入力してください'
      expect(page).to have_content 'ポイントを入力してください'
      expect(page).to have_content '商品イメージは画像ファイルのみ対応しています'
    end
  end

  context '正常パターン' do
    before do
      click_on '承諾'
    end
    it 'リクエストで登録された商品名・商品イメージ・ポイントが表示されている' do
      expect(page).to have_field 'name',  with: '商品名'
      expect(page).to have_field 'point', with: 300
      expect(find('#prev')[:src]).to match(/test.jpg/)
    end
    it '登録完了メッセージが表示される' do
      click_on '登録'
      expect(page).to have_content '「商品名」を承諾しました'
    end
    it '商品リクエスト一覧画面に遷移している' do
      click_on '登録'
      expect(current_path).to eq admin_product_requests_path
    end
    it '商品一覧画面に登録した商品が表示されている' do
      visit admin_products_path
      expect(page).to have_content '商品名'
    end
    it '商品リクエスト一覧から承諾した商品が消えている' do
      click_on '登録'
      expect{ find('#request-1') }.to raise_error(Capybara::ElementNotFound)
    end
    it '利用者に承諾したことをお知らせする(TODO:これはお知らせ機能実装時に作る)'
  end
end

describe '拒否' do
  before do
    login
    create_product_request
    visit admin_product_requests_path
    click_on '拒否'
  end
  it '商品リクエスト一覧画面から拒否した商品が削除される' do
    expect{ find('#product-1') }.to raise_error(Capybara::ElementNotFound)
  end
  it '削除メッセージが表示される' do
    expect(page).to have_content '「商品名」のリクエストを拒否しました'
  end
end