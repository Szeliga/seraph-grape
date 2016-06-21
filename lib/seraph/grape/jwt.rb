require 'jwt'

module Seraph
  module Grape
    module JWT
      def encode(payload)
        ::JWT.encode(payload, secret)
      end
      module_function :encode

      def decode(token)
        ::JWT.decode(token, secret).first
      rescue
        nil
      end
      module_function :decode

      private

      def secret
        String(Seraph.configuration.api_secret)
      end
      module_function :secret
    end
  end
end
