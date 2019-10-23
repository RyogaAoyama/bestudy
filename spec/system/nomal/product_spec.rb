require 'rails_helper'

describe '商品一覧機能' do
  let(:product) { FactoryBot.create(:new_product2, name: '商品', room_id: room.id, user_id: room.user_id) }
  let(:outer_product) { FactoryBot.create(:new_product2, :association, name: '他のルームの商品', user_id: room.user_id) }
  let(:room) { FactoryBot.create(:new_room2) }
  let(:user) { FactoryBot.create(:new_nomal_user, room_id: room.id, login_id: 'test_user1', password: 'test_user1') }

  context '商品がある場合' do
    it '所属しているルームの商品が表示されている' do
      product
      outer_product
      user
      new_login('test_user1', 'test_user1')
      expect(page).to have_content product.name
      expect(page).to_not have_content outer_product.name
    end
  end

  context '商品がない場合' do
    it '商品リクエストボタンを表示する' do
      room
      user
      new_login('test_user1', 'test_user1')
      expect(page).to have_content '商品をリクエストする'
      expect(page).to have_content '現在、商品がありません。商品をリクエストしてみましょう！'
    end
  end

  context 'ルームに所属していない場合' do
    let(:user) { FactoryBot.create(:new_nomal_user, login_id: 'test_user1', password: 'test_user1') }
    it 'ルーム申請ボタンを表示する' do
      user
      new_login('test_user1', 'test_user1')
      expect(page).to have_content 'ルーム申請する'
      expect(page).to have_content '現在、ルームに所属していません。ルーム申請してみましょう！'
    end
  end
end
