require 'rails_helper'

RSpec.describe "Api::V1::Trending", type: :request do
  describe "GET /api_v1_trending" do
    it 'return success' do
      get "/api/v1/trending/"
      expect(response).to have_http_status(:success)
    end

    it 'return the right hashtags' do
      last_trending = create(:trending, hashtags: {'#ruby': 2, '#tdd': 5, '#react': 8})
      get "/api/v1/trending/"
      expect(json["hashtags"]).to eq(last_trending.hashtags)
    end
  end
end
