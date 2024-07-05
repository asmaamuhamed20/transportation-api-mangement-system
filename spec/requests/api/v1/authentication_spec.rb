require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  describe 'POST /api/v1/sign_up' do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    context 'when the request is valid' do
      before { post '/api/v1/sign_up', params: valid_attributes }

      it 'creates a new user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/sign_up', params: { user: { email: 'invalid_email' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/sign_in' do
    let(:user) { create(:user) }  # Assuming you have FactoryBot configured

    context 'when the request is valid' do
      before { post '/api/v1/sign_in', params: { user: { email: user.email, password: user.password } } }

      it 'signs in the user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/sign_in', params: { user: { email: 'invalid_email', password: 'invalid_password' } } }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
