require "#{File.dirname(__FILE__)}/default_test_unit_runner"

# This class is directly inspired by a blog post by Adam Sanderson:
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
# It inherits DefaultGuardTestRunner and redefines only 2 methods in order to display failures
# as they happen (the default display them when all the tests are finished).
class FastfailGuardTestUnitRunner < DefaultGuardTestRunner
  
private
  
  def add_fault(fault)
    @faults << fault
    nl
    output("%3d) %s" % [@faults.length, fault.long_display])
    @already_outputted = true
  end
  
  def finished(elapsed_time)
    output_and_notify_results(@result.run_count, @result.assertion_count, @result.failure_count, @result.error_count, elapsed_time, :with_duration => true)
  end
  
end

Test::Unit::AutoRunner::RUNNERS["guard-fastfail"] = Proc.new { |r| FastfailGuardTestUnitRunner }