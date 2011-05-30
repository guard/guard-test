# encoding: utf-8
require 'guard'
require 'guard/guard'
# Thanks Aaron and Eric! http://redmine.ruby-lang.org/issues/show/3561
# Eric Hodel: "whenever you use a gem that replaces stdlib functionality you should use #gem before #require."
gem 'test-unit'
require 'test/unit'

module Guard
  class Test < Guard

    autoload :Runner,    'guard/test/runner'
    autoload :Inspector, 'guard/test/inspector'

    def initialize(watchers=[], options={})
      super
      @all_after_pass = options.delete(:all_after_pass)
      @all_on_start   = options.delete(:all_on_start)
      @runner = Runner.new(options)
    end

    def start
      ::Guard::UI.info("Guard::Test #{TestVersion::VERSION} is running!")
      run_all unless @all_on_start == false
    end

    def run_all
      paths = Inspector.clean(['test'])
      @last_failed = !@runner.run(paths, :message => 'Running all tests')
      !@last_failed
    end

    def run_on_change(paths)
      paths  = Inspector.clean(paths)
      passed = @runner.run(paths)

      if @all_after_pass == false
        passed
      else
        # run all the specs if the changed specs failed, like autotest
        if passed && @last_failed
          run_all
        else
          # track whether the changed specs failed for the next change
          @last_failed = !passed
        end
      end
    end

  end
end
