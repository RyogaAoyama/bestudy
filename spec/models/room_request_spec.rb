require 'rails_helper'

RSpec.describe RoomRequest, type: :model do
  let(:err_msg) { room_request.errors.messages[:regist_id] }
  let(:room_request) { RoomRequest.new }
  
  describe '空白チェック' do
    it 'エラー' do
      room_request.regist_id = ''
      room_request.valid?
      expect(err_msg).to include 'を入力してください'
    end
    it '正常' do
      room_request.regist_id = 'test'
      room_request.valid?
      expect(err_msg).to_not include 'を入力してください'
    end
  end

  describe 'ルーム存在チェック' do
    let(:room) { FactoryBot.create(:new_room) }
    it 'ルームが存在する' do
      room_request.regist_id = room.regist_id
      room_request.valid?
      expect(err_msg).to_not include 'このルームIDは存在しません'
    end
    it 'ルームが存在しない' do
      room_request.regist_id = 'test'
      room_request.valid?
      expect(err_msg).to include 'このルームIDは存在しません'
    end
  end
end
