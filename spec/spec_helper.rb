require 'rspec'
require 'guard/test'
ENV["GUARD_ENV"] = 'test'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:all) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
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
