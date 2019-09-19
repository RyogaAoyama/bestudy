require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  let(:curriculum) { Curriculum.new(room_id: 1, name: '名前') }
  let(:error_msg) { curriculum.errors.messages[:name] }
  
  context 'エラーパターン' do
    it '【空白】エラーが出る' do
      curriculum.name = '  '
      curriculum.valid?
      expect(error_msg).to include 'を入力してください'
    end
    it '【文字数】21文字でエラーが出る' do
      curriculum.name = 'a' * 21
      curriculum.valid?
      expect(error_msg).to include 'は20文字以内で入力してください'
    end
  end

  context '正常パターン' do
    it '【文字数】1文字でエラーが出ない' do
      curriculum.name = 'A'
      curriculum.valid?
      expect(error_msg).to_not include 'は20文字以内で入力してください'
    end
    it '【文字数】20文字でエラーが出ない' do
      curriculum.name = 'A' * 20
      curriculum.valid?
      expect(error_msg).to_not include 'は20文字以内で入力してください'
    end
  end
end
