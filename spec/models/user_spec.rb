require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { FactoryBot.create(:secret_question) }
  context '登録' do
    it '利用者が登録できる' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
      user.save

      user_record = User.all[0]
      password_check = user_record.authenticate('test_user1')

      expect(user_record.id).to                 eq(1)
      expect(user_record.name).to               eq('テストユーザー１')
      expect(user_record.login_id).to           eq('test_user1')
      expect(user_record.answer).to             eq('大元小学校')
      expect(user_record).to                    eq(password_check)
      expect(user_record.is_admin).to           eq(false)
      expect(user_record.secret_question_id).to eq(1)
    end
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

  describe 'アカウント編集' do
    before do
      FactoryBot.create(:secret_question2)
      FactoryBot.create(:user)
      @user = User.find(1)
    end
    context '秘密の質問' do
      it '秘密の質問が変更されている' do
        @user.secret_question_id = 2
        @user.save!
        expect(@user.secret_question_id).to eq(2)
      end
      it '質問の回答が変更されている' do
        @user.answer = '京都行きたいです。'
        @user.save!
        expect(@user.answer).to eq('京都行きたいです。')
      end
    end
  end
  after(:all) { SecretQuestion.all.destroy_all }
end
