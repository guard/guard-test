# encoding: utf-8
require File.expand_path('../default_guard_test_runner', __FILE__)

# This class is directly inspired by a blog post by Adam Sanderson:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
# It inherits DefaultGuardTestRunner and redefines only 2 methods in order to display failures
# as they happen (the default display them when all the tests are finished).
class FastfailGuardTestRunner < DefaultGuardTestRunner

  private

  def add_fault(fault)
    @faults << fault
    nl
    Guard::TestUI.color_print("%3d) %s" % [@faults.size, fault.long_display], :color => fault_color_name(fault))
    nl
  end

  def finished(elapsed_time)
    Guard::TestNotifier.notify(@result, elapsed_time) if GUARD_TEST_NOTIFY
    nl;nl
    Guard::TestUI.results(@result, elapsed_time)
    nl
  end

end

Test::Unit::AutoRunner::RUNNERS["guard-fastfail"] = Proc.new { |r| FastfailGuardTestRunner }
