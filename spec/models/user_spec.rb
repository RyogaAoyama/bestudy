require 'rails_helper'

RSpec.describe User, type: :model do
  context '登録' do
    let(:user) { FactoryBot.build(:user) }
    it '利用者が登録できる' do
      expect(user).to be_valid
      user.save

      user_record = User.all[0]
      password_check = user_record.authenticate('test_user1')
      expect(user_record.id).to eq(1)
      expect(user_record.name).to eq('テストユーザー１')
      expect(user_record.login_id).to eq('test_user1')
      expect(user_record.answer).to eq('大元小学校')
      expect(user_record).to eq(password_check)
      expect(user_record.is_admin).to eq(false)
      expect(user_record.secret_question_id).to eq(1)
    end
  end

  describe 'ログイン' do
    let(:user) { User.new( id: '', password: '') }
    it 'ログインIDの空白チェック' do
      user.valid?
      expect(user.errors.messages[:login_id]).to include 'を入力してください'
    end
    it 'パスワードの空白チェック' do
      user.valid?
      expect(user.errors.messages[:password]).to include 'を入力してください'
    end
  end
end
