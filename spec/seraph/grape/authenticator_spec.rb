require 'spec_helper'

RSpec.describe Seraph::Grape::Authenticator do
  describe '#call' do
    subject(:authenticator) { described_class.call(user, password) }
    let(:user) do
      DummyUser.new(1, Seraph::PasswordEncryptor.call('foobar12'))
    end

    context 'when password is valid' do
      let(:password) { 'foobar12' }

      it 'returns a JWT token with the user id in the payload' do
        expect(authenticator).to eq Seraph::Grape::JWT.encode(user_id: user.id)
      end
    end

    context 'when password is invalid' do
      let(:password) { 'invalid_password' }

      it { is_expected.to be_falsey }
    end
  end
end
