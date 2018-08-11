require 'rails_helper'

RSpec.describe "Api::V1::Likes", type: :request do
  describe "POST /api/v1/tweets/:id/like" do
    context "Unauthenticated" do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/users/-1'
    end

    context "Authenticated" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet) }

      context "valid tweet" do
        it 'status' do
          post "/api/v1/tweets/#{tweet.id}/like", headers: header_with_authentication(user)
          expect(response).to have_http_status(:success)
        end

        it '' do
          post "/api/v1/tweets/#{tweet.id}/like", headers: header_with_authentication(user)
          expect(tweet.liked_by user).to eq(true)
        end
      end

      context "invalid tweet" do
        it 'status' do
          post '/api/v1/tweets/-1/like', headers: header_with_authentication(user)
          expect(response).to have_http_status(:not_found)
        end
      end   
    end

    describe 'DELETE /api/v1/tweets/:id/like' do
      context "Unauthenticated" do
        it_behaves_like :deny_without_authorization, :put, '/api/v1/users/-1'
      end

      context "Authenticated" do
        let(:user) { create(:user) }
        let(:tweet) { create(:tweet) }

        context "unlike valid tweet" do

          before { delete "/api/v1/tweets/#{tweet.id}/like", headers: header_with_authentication(user) }
          it 'unlike' do
            expect(response).to have_http_status(:no_content)
          end

          it do
            expect(tweet.unliked_by user).to eq(true)
          end
        end

        context "unlike invalid tweet" do
          it 'unlike' do
            delete "/api/v1/tweets/-1/like", headers: header_with_authentication(user)
            expect(response).to have_http_status(:not_found)
          end
        end 
      end
    end
  end
end
