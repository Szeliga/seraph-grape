module Seraph
  module Grape
    module Helpers
      def authenticate!
        unauthorized! if auth_info.nil?
      end

      def auth_info
        @auth_info ||= Seraph::Grape::JWT.decode(headers['Authorization'])
      end

      def sign_in(user, password)
        result = Seraph::Grape::Authenticator.call(user, password)
        unauthorized! unless result
        result
      end

      def unauthorized!
        error!('Unauthorized', 401)
      end
    end
  end
end
