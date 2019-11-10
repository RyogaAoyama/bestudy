require 'rails_helper'

describe 'お気に入り機能' do
  let(:user) { FactoryBot.create(:new_nomal_user2, room_id: room.id, password: 'testuser1') }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:product) { FactoryBot.create(:new_product, user_id: room.user_id, room_id: room.id) }
  let(:good) { FactoryBot.create(:good, user_id: user.id, product_id: product.id) }

  before do
    product
    good
    new_login(user.login_id, 'testuser1')
  end

  describe 'お気に入り追加' do
    context 'お気に入りに追加していない場合' do
      let(:good) { '' }
      it 'ハートマークに色がついていないこと' do
        expect(find("#js-no-good-#{ product.id }")[:src]).to match(/no-good.svg/)
      end

      context 'ハートマークを押下した場合' do
        it 'お気に入りのデータが追加されること' do
          find("#js-no-good-#{ product.id }").click
          expect(page).to have_content "#{ product.name }をお気に入りに追加しました。"
          expect(Good.where(user_id: user.id)).to be_present
        end
      end
    end

    context 'お気に入りに追加している場合' do
      it 'ハートマークがお気に入り状態になっていること' do
        expect(find("#js-good-#{ product.id }")[:src]).to match(/good.svg/)
      end

      context 'ハートマークを押下した場合' do
        it 'お気に入りのデータが削除されること' do
          find("#js-good-#{ product.id }").click
          expect(page).to have_content "#{ product.name }をお気に入りから削除しました。"
          expect(Good.find_by(user_id: user.id)).to be_nil
        end
      end
    end
  end

  describe 'お気に入り一覧' do
    it 'お気に入りが表示されていること' do
      click_on 'お気に入り一覧', match: :first
      expect(find("#product-#{ good.product_id }")).to be_present
    end
  end
end
