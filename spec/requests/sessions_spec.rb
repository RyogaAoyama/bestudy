require 'rails_helper'

describe 'GET #logout' do
  before do
    FactoryBot.create(:user)
  end

  it 'リクエスト成功' do
    get logout_url
    expect(response.status).to eq 302
  end
end
