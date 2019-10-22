require 'rails_helper'

RSpec.describe RoomRequest, type: :model do
  let(:err_msg) { room_request.errors.messages[:regist_id] }
  let(:room_request) { RoomRequest.new }

  describe '#set_room' do
    describe 'ルーム存在チェック' do
      let(:room) { FactoryBot.create(:new_room) }
      it 'ルームが存在する' do
        room_request.regist_id = room.regist_id
        room_request.set_room
        expect(err_msg).to_not include 'が存在しません'
      end
      it 'ルームが存在しない' do
        room_request.regist_id = 'test'
        room_request.set_room
        expect(err_msg).to include 'が存在しません'
      end
    end

    describe '申請先のチェック' do
      context '同じルームに申請を出した場合' do
        let(:room_request_create) { FactoryBot.create(:room_request, room_id: room.id, user_id: user.id) }
        let(:user) { FactoryBot.create(:new_nomal_user) }
        let(:room) { FactoryBot.create(:new_room) }
        it 'エラー表示' do
          room_request_create
          room_request.regist_id = room.regist_id
          room_request.user_id = user.id
          room_request.set_room
          expect(err_msg).to include 'は既に申請済みです'
        end
      end
    end
  end
end
