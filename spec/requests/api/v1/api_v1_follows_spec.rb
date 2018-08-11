require 'rails_helper'

RSpec.describe "Api::V1::Follows", type: :request do
  describe "POST /api/v1/users/:id/follow" do

    context "Unauthenticated" do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/users/-1'
    end

    context "Authenticated" do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }

      context "valid user" do
        it 'status' do
          post "/api/v1/users/#{user2.id}/follow", headers: header_with_authentication(user)
          expect(response).to have_http_status(:success)
        end

        it '' do
          post "/api/v1/users/#{user2.id}/follow", headers: header_with_authentication(user)
          expect(user.following? user2).to eq(true)
        end
      end

      context "invalid tweet" do
        before { post '/api/v1/users/-1/follow', headers: header_with_authentication(user) }

        it 'status' do
          expect(response).to have_http_status(:not_found)
        end
      end   
    end

    describe 'DELETE /api/v1/users/:id/follow' do
      context "Unauthenticated" do
        it_behaves_like :deny_without_authorization, :delete, '/api/v1/users/-1'
      end

      context "Authenticated" do
        let(:user) { create(:user) }
        let(:user2) { create(:user) }

        context "unfollow valid user" do
          before { user.follow(user2) }

          it 'unfollow' do
            delete "/api/v1/users/#{user2.id}/follow", headers: header_with_authentication(user)
            expect(response).to have_http_status(:success)
          end
        end

        context "unfollow invalid user" do
          it 'unfollow' do
            delete "/api/v1/users/-1/follow", headers: header_with_authentication(user)
            expect(response).to have_http_status(:not_found)
          end
        end 
      end
    end
  end
end
