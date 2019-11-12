require 'rails_helper'

describe NoticeDecorator do
  let(:user) { FactoryBot.create(:new_nomal_user) }
  subject { decorate(notice).disp_notice }

  context 'type: 1' do
    let(:notice) { FactoryBot.build(:notice, :room_request_ok, user_id: user.id) }
    it 'ルーム承諾お知らせ' do
      is_expected.to eq 'ルーム申請が承諾されました！'
    end
  end

  context 'type: 3' do
    let(:notice) { FactoryBot.build(:notice, :room_request_send, user_id: user.id) }
    it 'ルーム申請のお知らせ' do
      is_expected.to eq "#{ user.name }が入室の許可を求めています。"
    end
  end

  context 'type: 4' do
    let(:notice) { FactoryBot.build(:notice, :product_buy, user_id: user.id) }
    it '商品購入のお知らせ' do
      is_expected.to eq "#{ user.name }が商品を購入しました。商品を届けましょう！"
    end
  end

  context 'type: 5' do
    let(:notice) { FactoryBot.build(:notice, :product_request_send, user_id: user.id) }
    it '商品リクエストのお知らせ' do
      is_expected.to eq "#{ user.name }から商品リクエストが届いてます。"
    end
  end

  context 'type: 2' do
    let(:notice) { FactoryBot.build(:notice, :product_request_ok, user_id: user.id) }
    it '商品リクエスト承諾お知らせ' do
      is_expected.to eq 'リクエストした商品が採用されました'
    end
  end
end
