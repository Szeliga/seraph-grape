require 'spec_helper'

RSpec.describe Seraph::Grape::Helpers do
  include Rack::Test::Methods

  def app
    DummyApi.new
  end

  describe '#authenticate!' do
    before do
      Seraph.configure do |config|
        config.api_secret = 'secret'
      end
      header('Authorization', jwt)
    end
    let(:user) { DummyUser.new(1, '123') }

    context 'when authentication is successful' do
      let(:jwt) { Seraph::Grape::JWT.encode(user_id: user.id) }

      it 'returns a 200 response' do
        get '/dummy_api/private'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq 'status' => 'authenticated'
      end

      it 'assigns the payload decoded from the Authorization header' do
        get '/dummy_api/private_info'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq 'user_id' => user.id
      end
    end

    context 'when authentication is unsuccessful' do
      let(:jwt) { '' }

      it 'returns a 401 response' do
        get '/dummy_api/private'
        expect(last_response.status).to eq(401)
      end
    end
  end

  describe '#sign_in' do
    let(:user) { DummyUser.new(1, Seraph::PasswordEncryptor.call('foobar12')) }

    context 'when valid credentials are passed' do
      it 'returns the JWT token' do
        post '/dummy_api/sign_in', email: 'dummyuser@gmail.com', password: 'foobar12'

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq(
          'jwt' => Seraph::Grape::JWT.encode(user_id: user.id)
        )
      end
    end

    context 'when invalid credentials are passed' do
      it 'returns status 401' do
        post '/dummy_api/sign_in', email: 'dummyuser@gmail.com', password: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
