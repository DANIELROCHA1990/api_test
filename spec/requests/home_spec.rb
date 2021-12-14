require 'rails_helper'

RSpec.describe 'Home', type: :request do
  let(:base_endpoint) { '/api/v1' }
  describe 'GET /index' do
    it 'returns status 200' do
      get base_endpoint
      expect(response).to have_http_status(:success)
    end
    it 'return success message' do
      get base_endpoint
      expect(response.body).to include('Ruby on Rails Challenge 20200810')
    end
  end
end
