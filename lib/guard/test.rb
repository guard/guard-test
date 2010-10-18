require 'rubygems'
require 'guard'
require 'guard/guard'

module Guard
  class Test < Guard
    
    autoload :Runner,    'guard/test/runner'
    autoload :Inspector, 'guard/test/inspector'
    
    def start
      Runner.set_test_unit_runner(options)
      UI.info "Guard::Test is guarding your tests!"
    end
    
    def run_all
      clean_and_run(["test"], :message => "Running all tests")
    end
    
    def run_on_change(paths)
      clean_and_run(paths)
    end
    
  private
    
    def clean_and_run(paths, options = {})
      paths = Inspector.clean(paths)
      Runner.run(paths, options) unless paths.empty?
    end
  end
end