require 'rails_helper'

describe '注文商品機能' do
  let(:room) { Room.find(delivery.room_id) }
  let(:user) { get_owner_user(room) }
  let(:product) { Product.find(delivery.product_id) }
  let(:delivery) { create_delivery }

  before do
    delivery
    # ログインIDとPW：admin_user1
    new_login(user.login_id, 'admin_user1')
    click_on '注文一覧'
  end

  describe '一覧' do
    context '正常パターン' do
      it '一覧を押下すると詳細画面に遷移する' do
        find("#order-#{ delivery.id }").click
        expect(current_path).to eq admin_delivery_path(delivery)
      end

      it '一覧メッセージが全て表示されている' do
        expect(page).to have_content delivery.created_at.strftime('%Y/%m/%d %H:%M')
        expect(page).to have_content "#{ delivery.user.name }さんが#{ product.name }を購入しました。商品をユーザーに届けましょう。"
      end
    end

    context 'エラーパターン' do
      context '注文した商品が削除された場合' do
        it '注文一覧に商品が表示されている' do
          product.update(is_deleted: true)
          expect(page).to have_selector "#order-#{ delivery.id }"
        end
      end

      context '商品を購入したユーザーがアカウントを削除した場合' do
        it '削除したユーザーの注文が表示されていない' do
          delivery.user.destroy
          expect { find("#order-#{ delivery.id }") }.to raise_error(Capybara::ElementNotFound)
        end
      end
    end
  end

  describe '詳細' do
    before do
      click_on "order-#{ delivery.id }"
    end

    context '正常パターン' do
      it '項目が全て表示されている' do
        expect(page).to have_content delivery.user.name
        expect(page).to have_content delivery.created_at.strftime('%Y/%m/%d %H:%M')
        expect(page).to have_content delivery.product.name
      end

      context '受け渡し完了した場合' do
        before { click_on '受け渡し完了' }
        it 'DBから受け渡し完了した商品が削除されている' do
          expect { Delivery.find(delivery.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it '注文履歴テーブルが更新される' do
          order_history = OrderHistory.find(delivery.order_history_id)
          expect(order_history.is_order_success).to eq true
        end

        it '受け渡し完了メッセージを出力する' do
          expect(page).to have_content '受け渡しが完了しました'
        end

        it '一覧なしのメッセージを表示する' do
          expect(page).to have_content '現在、注文されている商品はありません。'
        end

        it '注文一覧画面に遷移している' do
          expect(current_path).to eq admin_deliveries_path
        end
      end
    end
  end
end
