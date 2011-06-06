# encoding: utf-8
$:.push File.expand_path('../../../', File.dirname(__FILE__))

require 'test/unit/ui/console/testrunner'
require 'guard/test/ui'
require 'guard/test/notifier'

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
    Guard::TestUI.color_print(fault.single_character_display, :color => fault_color_name(fault))
    @was_faulty = true
  end

  def test_finished(name)
    Guard::TestUI.color_print(".", :color => :pass) unless @was_faulty
    @was_faulty = false
  end

  def finished(elapsed_time)
    Guard::TestNotifier.notify(@result, elapsed_time)
    nl;nl
    @faults.each_with_index do |fault, index|
      Guard::TestUI.color_puts("%3d) %s" % [index + 1, fault.long_display], :color => fault_color_name(fault))
      nl
    end
    Guard::TestUI.results(@result, elapsed_time)
    nl
  end

  def fault_color_name(fault)
    fault.class.name.split(/::/).last.downcase.to_sym
  end

end

Test::Unit::AutoRunner::RUNNERS["guard-default"] = Proc.new { |r| DefaultGuardTestRunner }
