require 'rails_helper'

describe 'ログインできるか確認' do
  before do
    visit root_path
  end
  describe 'ホーム画面の表示' do
    it 'ホーム画面の表示' do
      expect( page ).to have_content 'ログイン'
      expect( page ).to have_content '新規登録'
    end
  end

  describe 'ログイン画面の表示' do
    before do
      visit login_path
    end
    it 'ログイン画面の表示' do
      expect( page ).to have_button 'ログイン'
      expect( page ).to have_selector '#id'
      expect( page ).to have_selector '#password'
    end
  end
end