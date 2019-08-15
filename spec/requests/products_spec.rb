require 'rails_helper'
describe 'GET #index' do
  it 'ログイン画面に遷移する' do
    get '/products/1/index'
    #p response.status
    expect(response.status).to eq 302
  end
end