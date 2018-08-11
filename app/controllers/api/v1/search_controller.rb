module Api
  module V1
    class SearchController < Api::V1::ApiController #>
      def index
        tweets = Tweet.search(params[:query], page: (params[:page] || 1))
        users = User.search(params[:query], page: (params[:page] || 1))

        tweets_json = ActiveModelSerializers::SerializableResource.new(tweets, each_serializer: Api::V1::TweetSerializer)
        users_json = ActiveModelSerializers::SerializableResource.new(users, each_serializer: Api::V1::UserSerializer)

        render json: { tweets: tweets_json, users: users_json }
      end

      def autocomplete
        tweets = Tweet.search(params[:query], {
          fields: ["body"],
          match: :word_start,
          limit: 10,
          load: false,
          misspellings: {below: 5}
        }).map(&:body)

        users = User.search(params[:query], {
          fields: ["name", "email"],
          match: :word_start,
          limit: 10,
          load: false,
          misspellings: {below: 5}
        }).map(&:name)

        render json: { tweets: tweets, users: users }

      end
    end
  end
end