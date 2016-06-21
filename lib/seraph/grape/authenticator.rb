module Seraph
  module Grape
    class Authenticator
      private_class_method :new

      def self.call(user, password)
        new(user, password).call
      end

      def initialize(user, password)
        @user = user
        @password = password
      end

      def call
        return jwt_token if password_valid?
        false
      end

      private

      attr_reader :user, :password

      def jwt_token
        Seraph::Grape::JWT.encode(user_id: user.id)
      end

      def password_valid?
        Seraph::PasswordComparator.call(user.encrypted_password, password)
      end
    end
  end
end
