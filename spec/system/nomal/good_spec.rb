require 'rails_helper'

describe 'お気に入り機能' do
  let(:user) { FactoryBot.create(:new_nomal_user2, room_id: room.id, password: 'testuser1') }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:product) { FactoryBot.create(:new_product, user_id: room.user_id, room_id: room.id) }
  let(:good) { FactoryBot.create(:good, user_id: user, product_id: product) }

  before do
    new_login(user.login_id, 'testuser1')
  end

  describe 'お気に入り追加' do
    context 'お気に入りに追加していない場合' do
      let(:good) { '' }
      it 'ハートマークに色がついていないこと' do
        expect(find("#good")[:src]).to match(/no_good.jpg/)
      end

      context 'ハートマークを押下した場合' do
        it 'お気に入りのデータが追加されること' do
          click_on '#good'
          expect(Good.where(user_id: user.id)).to be_present
          expect(page).to have_content "#{ product.name }をお気に入りに追加しました。"
        end
      end
    end

    context 'お気に入りに追加している場合' do
      it 'ハートマークがピンク色になっていること' do
        expect(find("#no-good")).to match(/good.jpg/)
      end

      context 'ハートマークを押下した場合' do
        it 'お気に入りのデータが削除されること' do
          click_on '#no-good'
          expect(Good.find_by(user_id: user.id)).to be_nil
          expect(page).to have_content "#{ product.name }をお気に入りから削除しました。"
        end
      end
    end
  end

  describe 'お気に入り一覧' do
    it 'お気に入りが表示されていること' do
      click_on 'お気に入り一覧'
      expect(find("good-#{ good.id }")).to be_present
    end
  end
end