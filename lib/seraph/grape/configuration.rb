module Seraph
  class Configuration
    attr_accessor :api_secret

    def reset
      @api_secret = nil
      @pepper = nil
    end
  end
end
