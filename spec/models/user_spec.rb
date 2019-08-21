require 'rails_helper'

RSpec.describe User, type: :model do
  context '登録' do
    before(:all) { FactoryBot.create(:secret_question) }

    it '利用者が登録できる' do
      user = FactoryBot.create(:user)
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

    after(:all) { SecretQuestion.all.destroy_all }
  end

  describe '入力チェック' do
    describe '空白チェック' do
      user = User.new(id: '', password: '')
      user.valid?
      it '【ログインID】errorsにエラーメッセージが格納される' do
        expect(user.errors.messages[:login_id]).to include 'を入力してください'
      end
      it '【パスワード】errorsにエラーメッセージが格納される' do
        expect(user.errors.messages[:password]).to include 'を入力してください'
      end
    end
    describe '拡張子チェック' do
      it '【プロフィール画像】ファイルがアップロードできる'
      it '【プロフィール画像】errorsにエラーメッセージが表示される'
    end
  end

  describe 'アカウント情報の編集' do
    before do
      FactoryBot.create(:user)
    end
    let(:user) { User.find(1) }
    # TODO:値変更のテストコードわからん
    xit 'パスワードの変更' do
      expect{ 
        user.password = 'aaaaaaaa1'
        user.password_confirmation = 'aaaaaaaa1'
       }.to change{ user.password_digest }.to change{ user.update! }
    end
  end
end
