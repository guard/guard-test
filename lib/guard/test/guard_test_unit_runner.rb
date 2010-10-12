require "#{File.dirname(__FILE__)}/../test"
require "#{File.dirname(__FILE__)}/formatter"
require 'test/unit'
require 'test/unit/ui/console/testrunner'

# Thanks to Adam Sanderson for the good starting point
# http://endofline.wordpress.com/2008/02/11/a-custom-testrunner-to-scratch-an-itch/
# 
# This class inherits from Test::Unit' standard console TestRunner
# I'm just overriding some callbacks methods to display nice results
class GuardTestUnitRunner < Test::Unit::UI::Console::TestRunner
  include Formatter
  
  def initialize(suite, options={})
    super
    @examples_count = 0
    @failures = []
    @pendings = []
    $stdout.sync = true
  end
  
private
  def setup_mediator
    super
  end
  
  def attach_to_mediator
    @mediator.add_listener(Test::Unit::TestCase::STARTED, &method(:add_example))
    @mediator.add_listener(Test::Unit::TestResult::FAULT, &method(:add_anormal_result))
    @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::FINISHED, &method(:summary))
  end
  
  def add_example(name)
    @examples_count += 1
  end
  
  def add_anormal_result(anormal_result)
    type = anormal_result.class.name.split(/::/).last.downcase
    case type
    when 'failure'
      @failures << @examples_count
    when 'pending'
      @pendings << @examples_count
    else
    end
  end
  
  def summary(elapsed_time)
    (1..@examples_count).each_with_index do |example, index|
      if @failures.include?(index)
        print("\e[0;31mF\e[0m")
      elsif @pendings.include?(index)
        print("\e[0;33m*\e[0m")
      else
        print("\e[0;32m.\e[0m")
      end
    end
    
    message = guard_message(@examples_count, @failures.size, @pendings.size, elapsed_time, :color => true)
    image   = guard_image(@failures.size, @pendings.size)
    puts("\r\e #{message}")
    notify(message, image)
  end
  
  def output(something, color=nil, level=nil)
    # disable this method in order to avoid the output fired in the superclass
  end
  
end

Test::Unit::AutoRunner::RUNNERS["guard"] = Proc.new { |r| GuardTestUnitRunner }