# minispec

ENV["RACK_ENV"] = "test"

# Formatting - spec

require_relative '../env'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = %i(should expect) }
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
