require 'rails_helper'

describe PointCalc do
  let(:test_class) { Struct.new(:hoge) { include PointCalc } }
  let(:result_obj) { Struct.new(:result) }
  let(:hoge) { test_class.new }
  

  describe '#result_calc' do
    it '正しく計算されていること' do
      result_ary = []
      6.times do |i|
        result_ary << result_obj.new(i)
      end
      p result_ary
      result = hoge.result_calc(result_ary)
      expect(result).to eq 300
    end
  end

  describe '#add_point' do
    it '正しく計算されていること' do
      result = hoge.add_point(10, 10)
      expect(result).to eq 20
    end
  end

  describe '#buy?(pointObj, product.point)' do
    let(:user) { FactoryBot.build(:new_nomal_user) }
    let(:point) { FactoryBot.build(:point, user_id: user.id, point: 0, total: 0) }
    let(:product) { FactoryBot.build(:product, point: 300, user_id: user.id) }
    context 'ポイントが足りなかった場合' do
      it 'falseを返却' do
        expect(PointCalc.buy_calc(point, product.point)).to be_falsey
      end
    end

    context 'ポイントが足りる場合' do
      let(:point) { FactoryBot.build(:point, user_id: user.id, point: 5000, total: 0) }
      it 'trueを返す' do
        expect(PointCalc.buy_calc(point, product.point)).to be_falsey
      end
    end
  end

  describe '#buy_calc(pointObj, product.point)' do
    let(:user) { FactoryBot.build(:new_nomal_user) }
    let(:point) { FactoryBot.build(:point, user_id: user.id, point: 500, total: 0) }
    let(:product) { FactoryBot.build(:new_product2, point: 300) }
    it 'ポイントが計算されている' do
      point = PointCalc.buy_calc(point, product.point)
      expect(point.point).to eq 200
    end

    it '使った総額が計算されている' do
      point = PointCalc.buy_calc(point, product.point)
      expect(point.total).to eq 300
    end
  end
end