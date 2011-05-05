# encoding: utf-8
require "#{File.dirname(__FILE__)}/result_helpers"
require 'guard/notifier'

module Guard
  class Test
    class Notifier

      class << self
        def notify(result, elapsed_time)
          ::Guard::Notifier.notify(
            ResultHelpers.summary(result) + "\n\n" + ResultHelpers.duration(elapsed_time) + "\n",
            :title => "Test::Unit results",
            :image => result.failure_count > 0 ? :failed : :success
          )
        end
      end

    end
  end
end
