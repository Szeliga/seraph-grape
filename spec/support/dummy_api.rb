require 'rack/test'
require 'grape'
require 'seraph/grape/helpers'

class DummyApi < Grape::API
  helpers Seraph::Grape::Helpers
  prefix :dummy_api
  format :json

  get :private do
    authenticate!
    { status: 'authenticated' }
  end

  get :private_info do
    authenticate!
    auth_info
  end

  params do
    requires :email, type: String
    requires :password, type: String
  end
  post :sign_in do
    declared_params = declared(params)

    # Perform logic to find user by posted e-mail
    # - usually user = User.find_by_email(declared_params[:email])
    #
    # Here we just create a new instance of DummyUser
    # the same way we created it in the test
    user = DummyUser.new(1, Seraph::PasswordEncryptor.call('foobar12'))

    token = sign_in(user, declared_params[:password])
    status 200
    { jwt: token }
  end
end
