require 'rails_helper'


describe '履歴機能' do
  let(:room) { FactoryBot.create(:new_room2) }
  let(:product) { FactoryBot.create(:new_product2, room_id: room.id, user_id: room.user_id) }
  let(:user) { FactoryBot.create(:new_nomal_user, room_id: room.id, password: 'testuser1') }
  let(:order_history) { FactoryBot.create(:order_history, user_id: user.id, room_id: room.id, product_id: product.id) }
  
  before do
    order_history
    new_login(user.login_id, 'testuser1')
    click_on '注文履歴'
  end

  it '履歴一覧の項目が全て表示されている' do
    expect(page).to have_content product.name
    expect(page).to have_content "#{ product.point }pt"
    expect(page).to have_content "#{ product.created_at.strftime('%Y/%m/%d') }に購入"
    expect(find('#img')[:src]).to match(/test.jpg/)
  end

  context 'ルームに所属してない場合' do
    let(:user) { FactoryBot.create(:new_nomal_user, password: 'testuser1') }
    it 'メッセージを表示' do
      expect(page).to have_content 'ルーム申請する'
      expect(page).to have_content '現在、ルームに所属していません。ルーム申請してみましょう！'
    end
  end

  context '注文した商品が削除された場合' do
    let(:product) { FactoryBot.create(:new_product2, room_id: room.id, user_id: room.user_id, is_deleted: true) }
    it '履歴にメッセージを表示' do
      expect(page).to have_content 'この商品は削除されました'
    end
  end
  
  context '注文中の商品の場合' do
    it '履歴にメッセージを表示' do
      expect(page).to have_content '現在、注文中です'
    end
  end
  
  context '配送が完了した場合' do
    let(:order_history) { FactoryBot.create(
      :order_history, 
      user_id: user.id, 
      room_id: room.id, 
      product_id: product.id, 
      is_order_success: true
      ) }
    it '履歴にメッセージを表示' do
      expect(page).to have_content "#{ order_history.updated_at.strftime('%Y/%m/%d') }にお届け完了"
    end
  end

  context '注文がない場合' do
    let(:order_history) { '' }
    it 'メッセージを表示' do
      expect(page).to have_content '現在、注文はありません'
    end
  end
end