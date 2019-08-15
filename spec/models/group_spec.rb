require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '登録' do
    FactoryBot.create(:group)
    group = Group.all[0]
    it 'グループ名が保存されている' do
      expect(group.name).to eq '青山稜河'
    end
    it 'グループIDが保存されている' do
      expect(group.regist_id).to eq 'test_group'
    end
    it 'IDが保存されている' do
      expect(group.id).to eq 1
    end
  end

  group = Group.new
  describe '空白チェック' do
    it '【グループID】errorsにエラーメッセージが格納される' do
      group.regist_id = ''
      group.valid?
      expect(group.errors.messages[:regist_id]).to include 'を入力してください'
    end
  end

  describe '特殊文字チェック' do
    error_str = %w[, " ' . / \ = ? ! : ;]
    error_str.each do |str|
      it '【グループID】errorsにエラーメッセージが格納される' do
        group.regist_id = "testtt#{ str }"
        group.valid?
        expect(group.errors.messages[:regist_id]).to include 'に不正な文字が含まれています'
      end
    end
  end
  
  describe '文字数チェック' do
    context '文字数が5文字の場合'
      it '【グループID】errorsにエラーメッセージが格納される' do
        group.regist_id = 'a' * 5
        group.valid?
        expect(group.errors.messages[:regist_id]).to include '6文字以上10文字以内で入力してください'
      end

    context '文字数が6文字の場合' do
      it '【グループID】errorsにエラーメッセージが格納される' do
        group.regist_id = 'a' * 6
        group.valid?
        expect(group.errors.messages[:regist_id]).to_not include '6文字以上10文字以内で入力してください'
      end
    end

    context '文字数が11文字の場合' do
      it '【グループID】errorsにエラーメッセージが格納される' do
        group.regist_id = 'a' * 11
        group.valid?
        expect(group.errors.messages[:regist_id]).to include '6文字以上10文字以内で入力してください'
      end
    end

    context '文字数が10文字の場合' do
      it '【グループID】errorsにエラーメッセージが格納される' do
        group.regist_id = 'a' * 10
        group.valid?
        expect(group.errors.messages[:regist_id]).to_not include '6文字以上10文字以内で入力してください'
      end
    end
  end

  describe '重複チェック' do
    before do
      FactoryBot.create(:group, regist_id: 'testtest')
    end
    it '【グループID】errorsにエラーメッセージが格納される' do
      group.regist_id = 'testtest'
      group.valid?
      expect(group.errors.messages[:regist_id]).to_not include 'はすでに存在します'
    end
  end

  describe '全角文字チェック' do
    it '【グループID】errorsにエラーメッセージが格納される' do
      group.regist_id = 'ああああ'
      group.valid?
      expect(group.errors.messages[:regist_id]).to_not include 'は半角文字で入力してください'
    end
  end
end
