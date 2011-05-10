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
      @runner = Runner.new(options)
      super
    end

    def start
      ::Guard::UI.info "Guard::Test is running!"
    end

    def stop
      true
    end

    def reload
      true
    end

    def run_all
      paths = Inspector.clean(['test'])
      paths.empty? ? true : @runner.run(paths, :message => 'Running all tests')
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      paths.empty? ? true : @runner.run(paths)
    end

  end
end
