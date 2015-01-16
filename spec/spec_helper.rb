require 'guard/compat/test/helper'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  # config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before(:all) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end
end

# Thanks to Jonas Pfenniger for this!
# http://gist.github.com/487157
def dev_null(&block)
  orig_stdout = $stdout.dup # does a dup2() internally
  $stdout.reopen('/dev/null', 'w')
  yield
ensure
  $stdout.reopen(orig_stdout)
end
