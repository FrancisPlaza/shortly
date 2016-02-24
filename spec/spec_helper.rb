require 'simplecov'

SimpleCov.start do
  add_filter '/config'
  add_filter '/spec'
  add_filter '/lib/shortly/util/strrand'
end

ENV['RACK_ENV'] = 'test'
require File.expand_path("../../config/environment", __FILE__) # Loads up Shortly

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = false
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end 
  config.profile_examples = 10
  config.order = :random
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always){example.run}
  end  
  Kernel.srand config.seed
end

include Shortly # convenience for specs
