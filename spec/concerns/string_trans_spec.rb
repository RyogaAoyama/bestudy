require 'rails_helper'

describe StringTrans do
  
  let(:test_class) { Struct.new(:hoge) { include StringTrans } }
  let(:hoge) { test_class.new }

  describe '#half_size_change' do
    it '全角数字が半角数字に変換されている' do
      result = hoge.half_size_change('０００')
      expect(result).to eq '000'
    end
  end
end