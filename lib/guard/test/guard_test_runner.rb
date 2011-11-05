# encoding: utf-8
$:.push File.expand_path('../', __FILE__)

require 'test/unit/ui/console/testrunner'
require 'notifier'

# Thanks to Adam Sanderson for the really good starting point:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
#
# This class inherits from Test::Unit' standard console TestRunner
# I'm just overriding some callbacks methods to strip some outputs and display a notification on end
class GuardTestRunner < ::Test::Unit::UI::Console::TestRunner

  def initialize(suite, options = {})
    super
    @color_scheme["pass"]    = ::Test::Unit::Color.new("green", :foreground => true, :bold => true)
    @color_scheme["failure"] = ::Test::Unit::Color.new("red", :foreground => true, :bold => true)
  end

  protected

  # Test::Unit::UI::Console::TestRunner overrided methods
  def setup_mediator
    @mediator = ::Test::Unit::UI::TestRunnerMediator.new(@suite)
  end

  def finished(elapsed_time)
    super
    ::Guard::Test::Notifier.notify(@result, elapsed_time)
    nl
  end

  def fault_color_name(fault)
    fault.class.name.split(/::/).last.downcase.to_sym
  end

end

Test::Unit::AutoRunner.register_runner(:guard) { |r| GuardTestRunner }
