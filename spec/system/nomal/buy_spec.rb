require 'rails_helper'

describe '商品購入機能' do
  let(:product) { FactoryBot.create(:new_product2, user_id: room.user_id, room_id: room.id, point: 100) }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:user) { FactoryBot.create(:new_nomal_user, room_id: room.id, login_id: 'test_user1', password: 'test_user1') }
  let(:point) { FactoryBot.create(:point, user_id: user.id, point: 500) }

  before do
    room
    product
    user
    new_login('test_user1', 'test_user1')
    clcik_on '購入'
  end

  it '購入確認モーダルの項目が全て表示されている' do
    expect(page).to have_content product.name
    expect(page).to have_content product.point
    expect(find('#img')[:src]).to match(/public\/test.jpg/)
  end

  it '購入が完了する' do
    clcik_on '購入する'
    expect(page).to have_content "#{ product.name }を購入しました。"
    expect(current_path).to eq products_path
  end

  it '購入完了したらデータが追加されている' do
    clcik_on '購入する'
    expect(OrderHistory.where(user_id: user.id).size).to eq 1
    expect(Delivery.where(user_id: user.id).size).to eq 1
    expect(Notice.where(user_id: user.id)).to eq 1
  end

  context 'ポイントが足りなかった場合' do
    let(:point) { FactoryBot.create(:point, user_id: user.id, point: 0) }
    it 'エラーメッセージを表示' do
      clcik_on '購入する'
      expect(current_path).to eq products_path
      expect(page).to have_content "ポイントが足りません。"
    end
  end
end