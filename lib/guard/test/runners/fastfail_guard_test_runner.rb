# encoding: utf-8
require "#{File.dirname(__FILE__)}/default_guard_test_runner"

# This class is directly inspired by a blog post by Adam Sanderson:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
# It inherits DefaultGuardTestRunner and redefines only 2 methods in order to display failures
# as they happen (the default display them when all the tests are finished).
class FastfailGuardTestRunner < DefaultGuardTestRunner

  private

  def add_fault(fault)
    @faults << fault
    Guard::Test::UI.color_print("%3d) %s" % [@faults.size, fault.long_display], :color => fault_color_name(fault))
    nl;nl
    @already_outputted = true
  end

  def finished(elapsed_time)
    nl;nl
    Guard::Test::UI.results(@result, elapsed_time)
    Guard::Test::Notifier.notify(@result, elapsed_time) if GUARD_TEST_NOTIFY
  end

end

Test::Unit::AutoRunner::RUNNERS["guard-fastfail"] = Proc.new { |r| FastfailGuardTestRunner }
