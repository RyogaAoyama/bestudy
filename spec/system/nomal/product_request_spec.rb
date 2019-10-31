require 'rails_helper'

describe '商品リクエスト機能' do
  let(:room) { FactoryBot.create(:new_room2) }
  let(:user) { FactoryBot.create(:new_nomal_user, room_id: room.id, password: 'testuser1') }
  describe '登録' do
    let(:input_name) { fill_in 'name', '商品名' }
    let(:input_img) { attach_file 'product_img', 'public/test.jpg' }
    before do
      new_login(user.login_id, 'testuser1')
      # TODO: セレクタ指定できるか確認
      click_on '#request-btn'
      input_name
      input_img
      click_on 'リクエスト'
    end
    context '正常パターン' do
      it '登録完了メッセージが表示される' do
        expect(current_path).to eq admin_product_requests_path
        expect(page).to have_content '「商品名」をリクエストしました'
      end
      it '管理者にリクエストしたことをお知らせする' do
        expect(Notice.find_by(room_id: room.id)).to be_present
      end

      context '画像が指定されなかった場合' do
        it 'デフォルトの画像を挿入する' do
          expect(find('.product_img')[:src]).to match(/default.jpg/)
        end
      end
    end

    context 'エラーパターン' do
      let(:input_name) { fill_in 'name', '' }
      let(:input_img) { attach_file 'product_img', 'public/test.txt' }
      it 'エラーメッセージが表示される' do
        expect(page).to have_content '商品名を入力してください'
        expect(page).to have_content '商品イメージは画像ファイルのみ対応しています'
      end
    end
  end
  
  describe '一覧' do
    let(:product) { FactoryBot.create(:new_product2, room_id: room.id, user_id: user.id) }
    let(:product_request) { FactoryBot.create(:product_request, product_id: product.id, user_id: user.user_id) }

    before do
      new_login(user.login_id, 'testuser1')
      click_on 'リクエスト一覧'
    end

    it 'リクエストした商品が表示されている' do
      expect(page).to have_field 'name', with: product.name
      expect(find("#img-#{ product.id }")[:src]).to match(/test.jpg/)
    end

    context '取り消し' do
      it '商品リクエスト一覧画面から取り消しした商品が削除される' do
        click_on '取り消し'
        expect{ find("#product-#{ product.id }") }.to raise_error(Capybara::ElementNotFound)
        expect(Product.find_by(id: product_request.product_id)).to be_blank
      end
      it '削除メッセージが表示される' do
        click_on '取り消し'
        expect(page).to have_content "#{ product.name }のリクエストを取り消しました。"
      end
    end
  end
end