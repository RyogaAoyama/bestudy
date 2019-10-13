require 'rails_helper'

RSpec.describe User, type: :model do
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
      it '【プロフィール画像】errorsにエラーメッセージが表示される' do
        user = User.new
        File.open('public/test.txt') do |f|
          user.image.attach(io: f, filename: "test.txt")
        end
        user.valid?
        expect(user.errors.messages[:image]).to include 'は画像ファイルのみ対応しています'
      end
    end
  end
end
