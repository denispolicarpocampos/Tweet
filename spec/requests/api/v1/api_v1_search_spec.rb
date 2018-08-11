require 'rails_helper'

RSpec.describe "Api::V1::Search", search: true do
  describe 'GET /api/v1/search?query=:query' do

    user = User.create!(name: "test user", email: 'teste@teste.com', password: 'secret123')
    tweet = Tweet.create!(body: 'test tweet', user: user)
    Tweet.search_index.refresh
    User.search_index.refresh

    it 'return tweets and user that contain a query' do
      get "/api/v1/search?query=test"
      expect(json["tweets"]).to include(serialized(Api::V1::TweetSerializer, tweet))
      expect(json["users"]).to include(serialized(Api::V1::UserSerializer, user))
    end

    it 'tweets and user dont match with the query' do

      get "/api/v1/search?query=error"

      expect(json["tweets"]).not_to include(serialized(Api::V1::TweetSerializer, tweet))
      expect(json["users"]).not_to include(serialized(Api::V1::UserSerializer, user))
    end
  end

  describe 'GET /api/v1/autocomplete?query=:query' do

    it 'display users and tweets related with query' do
      user = User.create!(name: "First cool user", email: 'teste@teste.com', password: 'secret123')
      tweet = Tweet.create!(body: 'this tweet is to cool people', user: user)
      another_tweet = Tweet.create!(body: 'This creature has big head', user: user)
      Tweet.search_index.refresh
      User.search_index.refresh

      get "/api/v1/autocomplete?query=coo"

      expect(json["tweets"]).to include(tweet.body)
      expect(json["tweets"]).not_to include(another_tweet.body)
      expect(json["users"]).to include(user.name)
    end

    it 'It doenst display users and tweets that dont match with query' do
      user = User.create!(name: "First user is the faster guy", email: 'teste@teste.com', password: 'secret123')
      tweet = Tweet.create!(body: 'this tweet is about watermelon', user: user)
      another_tweet = Tweet.create!(body: 'This creature has big head', user: user)
      Tweet.search_index.refresh
      User.search_index.refresh

      get "/api/v1/autocomplete?query=coo"

      expect(json["tweets"]).not_to include(tweet.body)
      expect(json["tweets"]).not_to include(another_tweet.body)
      expect(json["users"]).not_to include(user.name)
    end
  end
end