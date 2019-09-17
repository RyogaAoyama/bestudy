require 'rails_helper'

RSpec.describe Subject, type: :model do
  let(:subject) { Subject.new(room_id: 1, name: '名前') }
  let(:error_msg) { subject.errors.messages[:name] }
  
  context 'エラーパターン' do
    it '【空白】エラーが出る' do
      subject.name = '  '
      subject.valid?
      expect(error_msg).to include 'を入力してください'
    end
    it '【文字数】21文字でエラーが出る' do
      subject.name = 'a' * 21
      subject.valid?
      expect(error_msg).to include 'は20文字以内で入力してください'
    end
    it '【重複】エラーが出る' do
      FactoryBot.create(:subject)
      subject.name = 'データベース設計'
      subject.valid?
      expect(error_msg).to include 'はすでに存在します'
    end
  end

  context '正常パターン' do
    it '【文字数】1文字でエラーが出ない' do
      subject.name = 'A'
      subject.valid?
      expect(error_msg).to_not include 'は20文字以内で入力してください'
    end
    it '【文字数】20文字でエラーが出ない' do
      subject.name = 'A' * 20
      subject.valid?
      expect(error_msg).to_not include 'は20文字以内で入力してください'
    end
  end
end
