require 'rails_helper'

describe 'ログインできるか確認' do
  describe 'ホーム画面の表示' do
    before do
      visit root_path
    end
    it 'ホーム画面の表示' do
      expect( page ).to have_content 'ログイン'
      expect( page ).to have_content '新規作成'
    end
  end
end