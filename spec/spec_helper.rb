require 'rspec'
require 'guard/test'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

RSpec.configure do |config|
  config.order = :random
  config.filter_run focus: ENV['CI'] != 'true'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end

  config.before(:each) do
    # Stub all UI methods, so no visible output appears for the UI class
    ::Guard::UI.stub(:info)
    ::Guard::UI.stub(:warning)
    ::Guard::UI.stub(:error)
    ::Guard::UI.stub(:debug)
    ::Guard::UI.stub(:deprecation)
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
