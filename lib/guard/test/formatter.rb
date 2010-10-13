module Formatter
  
  def guard_messages(example_count, failure_count, pending_count, duration, options = {})
    [
      guard_cli_message(example_count, failure_count, pending_count, duration, { :color => true, :long => true }.merge!(options)),
      guard_notification_message(example_count, failure_count, pending_count, duration, options)
    ]
  end
  
  def guard_notification_message(example_count, failure_count, pending_count, duration, options = {})
    duration_text(duration) + results_text(example_count, failure_count, pending_count)
  end
  
  def guard_cli_message(example_count, failure_count, pending_count, duration, options = {})
    message = duration_text(duration, options)
    message << (failure_count > 0 ? "\e[0;31m" : (pending_count > 0 ? "\e[0;33m" : "\e[0;32m")) if options[:color]
    message << results_text(example_count, failure_count, pending_count)
    message << "\e[0m" if options[:color]
    message
  end
  
  # failed | pending | success
  def guard_image(failure_count, pending_count)
    icon = if failure_count > 0
      :failed
    elsif pending_count > 0
      :pending
    else
      :success
    end
  end
  
  def notify(message, image)
    Guard::Notifier.notify(message, :title => "Test::Unit results", :image => image)
  end
  
private
  
  def results_text(example_count, failure_count, pending_count)
    message = "#{example_count} examples, #{failure_count} failures"
    message << " (#{pending_count} pending)" if pending_count > 0
    message
  end
  
  def duration_text(duration, options = {})
    "\n #{"Finished " if options[:long]}in #{duration} seconds\n"
  end
  
end