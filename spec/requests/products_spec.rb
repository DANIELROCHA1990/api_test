# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Products', type: :request do
  shared_examples_for 'authentication' do |verb, endpoint, headers|
    context 'Succes to Login' do
      let!(:headers) { User.create(email: 'mainochallenge@teste.com', password: '123456') }
      it "checks if authentication is working for #{endpoint}" do
        subject { verb endpoint, headers: headers }
        expect(subject).should be_success
      end
    end

    context 'Fail to Login' do
      let!(:invalid_headers) { User.last(email: 'mainochallenge@teste.com', authentication_token: nil) }
      it 'checks invalid authentication' do
        subject { verb endpoint, headers: invalid_headers }
        expect(subject).to raise_error('message: You need to Login')
      end
    end

    # it_behaves_like 'authentication'
    it_behaves_like :get, '/api/v1/products', headers
    it_behaves_like :get, "/api/v1/products/#{product.id}", headers
    it_behaves_like :post, '/api/v1/products', headers
    it_behaves_like :delete, "/api/v1/products/#{product.id}", headers
    it_behaves_like :patch, "/api/v1/products/#{product.id}", headers
  end

  # Actions Tests
  describe 'GET /index' do
    it 'returns all products' do
      get '/api/v1/products'
      expect(JSON.parse(response.body).count).to eq(Product.count)
    end
  end

  describe 'GET /show' do
    let(:product) { Product.create(title: 'title', product_type: 'product_type') }
    subject { get "/api/v1/products/#{product.id}" }

    it 'shows the requested product' do
      subject
      expect(JSON.parse(response.body)['data']['id']).to eq(product.id)
    end
  end

  describe 'POST /api/v1/products' do
    subject { post '/api/v1/products', params: { products: products_file } }

    context 'success' do
      let(:products_file) { fixture_file_upload(file_fixture('products.json')) }
      it 'create a new product' do
        # quando a requisicao for feita a qtde de produtos seja alterada dentro do bd
        expect { subject }.to change(Product, :count)
      end
    end

    context 'failure' do
      let(:products_file) { fixture_file_upload(file_fixture('products_fail.json')) }
      it 'failure in create a new product' do
        # quando a requisicao for feita a qtde de produtos seja alterada dentro do bd
        expect { subject }.not_to change(Product, :count)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:product) { Product.create(title: 'um titulo', product_type: 'tipo do produto') }
    subject { delete "/api/v1/products/#{product.id}" }

    it 'destroys the requested product' do
      expect { subject }.to change(Product, :count).by(-1)
    end
  end

  describe 'PATCH /update' do
    let(:product) { Product.create(title: 'title', product_type: 'product_type') }
    let(:product_params) { { title: 'new title', product_type: 'product_type' } }
    subject { patch "/api/v1/products/#{product.id}", params: { product: product_params } }
    it 'shows the requested product' do
      expect { subject }.to change { Product.find(product.id).title }.from('title').to('new title')
    end
  end
end
