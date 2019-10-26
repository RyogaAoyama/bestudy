require 'rails_helper'

RSpec.describe Point, type: :model do
  describe '#buy_calc(product.point)' do
    let(:point) { Point.new(point: 500, total: 0) }
    let(:product) { Product.new(point: 300) }
    it 'ポイントが計算されている' do
      point.buy_calc(product.point)
      expect(point.point).to eq 200
    end

    it '使った総額が計算されている' do
      point.buy_calc(product.point)
      expect(point.total).to eq 300
    end

    context 'ポイントが足りなかった場合' do
      let(:point) { Point.new(point: 0, total: 0) }
      it 'falseを返却' do
        expect(point.buy_calc(product.point)).to be_falsey
      end
    end
  end
end
