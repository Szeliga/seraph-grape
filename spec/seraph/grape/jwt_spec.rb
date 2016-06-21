require 'spec_helper'

RSpec.describe Seraph::Grape::JWT do
  describe '#encode' do
    let(:payload) { {} }
    subject(:token) { described_class.encode(payload) }

    context 'when api_secret configuration option is set' do
      let(:api_secret) { 'secret' }
      before do
        Seraph.configure do |config|
          config.api_secret = api_secret
        end
      end

      it 'returns an encoded JWT token' do
        expect(token).to eq JWT.encode(payload, api_secret)
      end
    end

    context 'when api_secret configuration option is not set' do
      let(:api_secret) { nil }

      it 'returns an encoded JWT token' do
        expect(token).to eq JWT.encode(payload, '')
      end
    end
  end
end
