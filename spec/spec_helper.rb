require 'pry'
require 'rspec'
require 'codeclimate-test-reporter'
require 'seraph'
require 'seraph/grape'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    Seraph.configuration.reset
  end

  config.order = :random
  Kernel.srand config.seed
end
