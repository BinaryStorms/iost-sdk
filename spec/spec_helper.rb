# frozen_string_literal: true

require 'coveralls'
require 'bundler/setup'

Coveralls.wear!

RSpec.shared_context 'Global Constants' do
  let(:testnet_url) { 'http://13.52.105.102:30001' }
end

RSpec.configure do |config|
  config.include_context 'Global Constants'
  config.color = true
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
