# encoding: utf-8
require 'guard'
require 'guard/guard'

# Thanks Aaron and Eric! http://redmine.ruby-lang.org/issues/show/3561
# Eric Hodel: "whenever you use a gem that replaces stdlib functionality you should use #gem before #require."
begin
  require 'turn'
  gem 'test-unit' if RUBY_VERSION >= '1.9'
rescue LoadError
  gem 'test-unit'
end

require 'test/unit'

module Guard
  class Test < Guard

    autoload :Runner,    'guard/test/runner'
    autoload :Inspector, 'guard/test/inspector'

    def initialize(watchers=[], options={})
      super
      @options = {
        :all_on_start   => true,
        :all_after_pass => true,
        :keep_failed    => true
      }.update(options)
      @last_failed  = false
      @failed_paths = []

      @runner = Runner.new(options)
    end

    def start
      ::Guard::UI.info("Guard::Test #{TestVersion::VERSION} is running!")
      run_all if @options[:all_on_start]
    end

    def run_all
      passed = @runner.run(Inspector.clean(['test']), :message => 'Running all tests')

      @failed_paths = [] if passed
      @last_failed  = !passed
    end

    def reload
      @failed_paths = []
    end

    def run_on_change(paths)
      paths += @failed_paths if @options[:keep_failed]
      passed = @runner.run(Inspector.clean(paths))

      if passed
        # clean failed paths memory
        @failed_paths -= paths if @options[:keep_failed]
        # run all the tests if the changed tests failed, like autotest
        run_all if @last_failed && @options[:all_after_pass]
      else
        # remember failed paths for the next change
        @failed_paths += paths if @options[:keep_failed]
        # track whether the changed tests failed for the next change
        @last_failed = true
      end
    end

  end
end
