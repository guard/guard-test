require "#{File.dirname(__FILE__)}/../formatter"
require "#{File.dirname(__FILE__)}/../../test"
gem 'test-unit' if RUBY_VERSION =~ %r(1\.9\.2) # Thanks Aaron! http://redmine.ruby-lang.org/issues/show/3561
require 'test/unit'
require 'test/unit/ui/console/testrunner'

# Thanks to Adam Sanderson for the really good starting point:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
# 
# This class inherits from Test::Unit' standard console TestRunner
# I'm just overriding some callbacks methods to display some nicer results
class DefaultGuardTestRunner < Test::Unit::UI::Console::TestRunner
  include Formatter
  
  def initialize(suite, options = {})
    super
    @use_color = true
  end
  
protected
  
  # Test::Unit::UI::Console::TestRunner overrided methods
  def setup_mediator
    @mediator = Test::Unit::UI::TestRunnerMediator.new(@suite)
  end
  
  def started(result)
    @result = result
  end
  
  def test_started(name) # silence!
  end
  
  def add_fault(fault)
    @faults << fault
    output_single(fault.single_character_display, fault_color_name(fault))
    @already_outputted = true
  end
  
  def test_finished(name)
    output_single(".", "pass") unless @already_outputted
    @already_outputted = false
  end
  
  def finished(elapsed_time)
    nl
    super
    notify_results(@result.run_count, @result.assertion_count, @result.failure_count, @result.error_count, elapsed_time)
  end
  
  def fault_color_name(fault)
    fault.class.name.split(/::/).last.downcase
  end
  
end

Test::Unit::AutoRunner::RUNNERS["guard-default"] = Proc.new { |r| DefaultGuardTestRunner }