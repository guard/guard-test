# encoding: utf-8
require 'test/unit/ui/console/testrunner'
require "#{File.dirname(__FILE__)}/../ui"
require "#{File.dirname(__FILE__)}/../notifier"

# Thanks to Adam Sanderson for the really good starting point:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
#
# This class inherits from Test::Unit' standard console TestRunner
# I'm just overriding some callbacks methods to display some nicer results
class DefaultGuardTestRunner < Test::Unit::UI::Console::TestRunner

  def initialize(suite, options={})
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
    nl
  end

  def test_started(name)
    # silence!
  end

  def add_fault(fault)
    @faults << fault
    Guard::Test::UI.color_print(fault.single_character_display, :color => fault_color_name(fault))
    @already_outputted = true
  end

  def test_finished(name)
    Guard::Test::UI.color_print(".", :color => :pass) unless @already_outputted
    @already_outputted = false
  end

  def finished(elapsed_time)
    nl;nl
    # super
    @faults.each_with_index do |fault, index|
      Guard::Test::UI.color_puts("%3d) %s" % [index + 1, fault.long_display], :color => fault_color_name(fault))
      nl
    end
    Guard::Test::UI.results(@result, elapsed_time)
    Guard::Test::Notifier.notify(@result, elapsed_time) if GUARD_TEST_NOTIFY
  end

  def fault_color_name(fault)
    fault.class.name.split(/::/).last.downcase.to_sym
  end

end

Test::Unit::AutoRunner::RUNNERS["guard-default"] = Proc.new { |r| DefaultGuardTestRunner }
