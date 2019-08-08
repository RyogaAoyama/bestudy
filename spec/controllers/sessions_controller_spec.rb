require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #admin_login" do
    it "returns http success" do
      get :admin_login
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #nomal_login" do
    it "returns http success" do
      get :nomal_login
      expect(response).to have_http_status(:success)
    end
  end

end
