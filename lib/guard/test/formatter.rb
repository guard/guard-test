require "#{File.dirname(__FILE__)}/../test"

module Formatter
  
  def output_results(test_count, assertion_count, failure_count, error_count, duration, options = {})
    output(duration_text(duration, options)) if options[:with_duration]
    color = (failure_count > 0 ? "failure" : (error_count > 0 ? "error" : "pass"))
    output(results_text(test_count, assertion_count, failure_count, error_count), color)
  end
  
  def notify_results(test_count, assertion_count, failure_count, error_count, duration)
    notify(
      results_text(test_count, assertion_count, failure_count, error_count) + duration_text(duration, :short => true),
      image(failure_count)
    )
  end
  
  def output_and_notify_results(test_count, assertion_count, failure_count, error_count, duration, options = {})
    output_results(test_count, assertion_count, failure_count, error_count, duration, options)
    notify_results(test_count, assertion_count, failure_count, error_count, duration)
  end
  
  def image(failure_count)
    failure_count > 0 ? :failed : :success
  end
  
  def notify(message, image)
    Guard::Notifier.notify(message, :title => "Test::Unit results", :image => image)
  end
  
  def output_single(something, color_name = "reset")
    something = "%s%s%s" % [color_sequence(color_name), something, color_sequence("reset")]
    $stdout.write(something)
    $stdout.flush
    true
  end
  
  def output(something, color_name = "reset")
    output_single(something, color_name)
    $stdout.puts
  end
  
private
  
  def color_sequence(color_name = "reset")
    "\e[0#{color_code(color_name)}m"
  end
  
  def color_code(name = "reset")
    { "pass" => ";32", "failure" => ";31", "pending" => ";33", "error" => ";35", "reset" => "" }[name]
  end
  
  def results_text(test_count, assertion_count, failure_count, error_count)
    "#{test_count} tests, #{assertion_count} asserts, #{failure_count} fails, #{error_count} errors"
  end
  
  def duration_text(duration, options = {})
    "\n\n#{"Finished " unless options[:short]}in #{duration} seconds\n"
  end
  
end