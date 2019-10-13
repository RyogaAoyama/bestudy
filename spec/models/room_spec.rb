require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'エラーチェック' do
    room = Room.new
    let(:err_messages) { room.errors.messages[:regist_id] }

    describe '空白チェック' do
      it '【ルームID】errorsにエラーメッセージが格納される' do
        room.regist_id = ''
        room.valid?
        expect(err_messages).to include 'を入力してください'
      end
    end

    describe '特殊文字チェック' do
      error_str = %w[, " ' . / \ = ? ! : ;]
      error_str.each do |str|
        it '【ルームID】errorsにエラーメッセージが格納される' do
          room.regist_id = "testtt#{ str }"
          room.valid?
          expect(err_messages).to include 'に不正な文字が含まれています'
        end
      end
    end

    describe '文字数チェック' do
      context '文字数が5文字の場合'
        it '【ルームID】errorsにエラーメッセージが格納される' do
          room.regist_id = 'a' * 5
          room.valid?
          expect(err_messages).to include 'は6文字以上10文字以内で入力してください'
        end

      context '文字数が6文字の場合' do
        it '【ルームID】errorsにエラーメッセージが格納される' do
          room.regist_id = 'a' * 6
          room.valid?
          expect(err_messages).to_not include 'は6文字以上10文字以内で入力してください'
        end
      end

      context '文字数が11文字の場合' do
        it '【ルームID】errorsにエラーメッセージが格納される' do
          room.regist_id = 'a' * 11
          room.valid?
          expect(err_messages).to include 'は6文字以上10文字以内で入力してください'
        end
      end

      context '文字数が10文字の場合' do
        it '【ルームID】errorsにエラーメッセージが格納される' do
          room.regist_id = 'a' * 10
          room.valid?
          expect(err_messages).to_not include 'は6文字以上10文字以内で入力してください'
        end
      end
    end

    describe '重複チェック' do
      before do
        create_room
      end
      it '【ルームID】errorsにエラーメッセージが格納される' do
        room.regist_id = 'test_room'
        room.valid?
        expect(err_messages).to include 'はすでに存在します'
      end
    end

    describe '全角文字チェック' do
      it '【ルームID】errorsにエラーメッセージが格納される' do
        room.regist_id = 'ああああ'
        room.valid?
        expect(err_messages).to include 'は半角文字で入力してください'
      end
    end
  end
end
