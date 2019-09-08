require 'rails_helper'

describe '一覧' do
  before(:all) { login }
  before { visit admin_product_requests_path_path }
  it '商品リクエストが存在しないメッセージが表示されている' do
    expect(page).to have_content '現在リクエストは届いていません'
  end
  it '商品リクエストの項目が全て表示されている' do
    create_product_request
    visit admin_product_requests_path_path
    expect(page).to have_content '商品名'
    expect(page).to have_content 'testuser2'
    expect(page).to match(/test.jpg/)
    expect(page).to have_content '2019/9/6'
    expect(page).to have_button '承認'
    expect(page).to have_button '拒否'
  end
  after(:all) { clear }
end

describe '承諾' do
  before(:all) { login }
  before do
    create_product_request
    visit admin_product_requests_path
  end
  context 'エラーパターン' do
    it 'エラーメッセージが表示される' do
      click_on '承諾'
      fill_in 'name',  with: '  '
      fill_in 'point', with: '  '
      attach_file 'product_img', 'public/test.txt'
      click_on '登録'
      expect(page).to have_content '商品名を入力してください'
      expect(page).to have_content 'ポイントを入力してください'
      expect(page).to have_content '商品イメージは画像ファイルのみ対応しています'
    end
  end

  context '正常パターン' do
    before do
      fill_in 'point', with: 300
      click_on '登録'
    end
    it 'リクエストで登録された商品名と商品イメージが表示されている' do
      expect(page).to have_selector 'request-1', with: '商品名'
      expect(find('#request-img1')[:src]).to match(/test.jpg/)
    end
    it '登録完了メッセージが表示される' do
      expect(page).to have_content '「商品名」を登録しました'
    end
    it '商品リクエスト一覧画面に遷移している' do
      expect(current_user).to eq admin_product_requests
    end
    it '商品一覧画面に登録した商品が表示されている' do
      visit admin_products
      expect(page).to have_selector 'product-1', with: '商品名'
    end
    it '商品リクエスト一覧から承諾した商品が消えている' do
      expect(find('#request-1')).to raise_error(Capybara::ElementNotFound)
    end
    it '利用者に承諾したことをお知らせする(TODO:これはお知らせ機能実装時に作る)'
  end
  after(:all) { clear }
end

describe '拒否' do
  before(:all) { login }
  before do
    create_product_request
    visit admin_product_requests_path
    click_on '拒否'
  end
  it '商品リクエスト一覧画面から拒否した商品が削除される' do
    exepct(find('#request-1')).to raise_error(Capybara::ElementNotFound)
  end
  it '削除メッセージが表示される' do
    expect(page).to have_content '「商品名」を拒否しました'
  end
  it '利用者に削除したことをお知らせする(TODO:これはお知らせ機能実装時に作る)'
  it '削除が失敗した時にメッセージを表示する' do
    expect(page).to have_content '削除に失敗しました。再度時間を置いてお試しください'
  end
  after(:all) { clear }
end