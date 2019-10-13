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
end