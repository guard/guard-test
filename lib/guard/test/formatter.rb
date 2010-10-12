module Formatter
  
  def guard_message(example_count, failure_count, pending_count, duration, options = {})
    message = if options[:color]
      failure_count > 0 ? "\e[0;31m" : (pending_count > 0 ? "\e[0;33m" : "\e[0;32m")
    else
      ""
    end
      
    message << "#{example_count} examples, #{failure_count} failures"
    if pending_count > 0
      message << " (#{pending_count} pending)"
    end
    message << "\nin #{duration} seconds"
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
  
end