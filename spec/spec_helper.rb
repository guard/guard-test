# encoding: utf-8
require 'rspec'
require 'guard/test'
require 'guard/test/runners/default_guard_test_runner'
require 'guard/test/runners/fastfail_guard_test_runner'

ENV["GUARD_ENV"] = 'test'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:all) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end
  config.after(:all) do
    Guard::Notifier.turn_on
  end

  config.before(:each) do
    Guard::Notifier.turn_off
  end

end

# Thanks to Jonas Pfenniger for this!
# http://gist.github.com/487157
def dev_null(&block)
  begin
    orig_stdout = $stdout.dup # does a dup2() internally
    $stdout.reopen('/dev/null', 'w')
    yield
  ensure
    $stdout.reopen(orig_stdout)
  end
end
