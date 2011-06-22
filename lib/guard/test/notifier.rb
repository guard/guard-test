# encoding: utf-8
require 'guard'
require 'guard/notifier'
require 'guard/test/result_helpers'

module Guard
  module TestNotifier

    def self.notify(result, elapsed_time)
      ::Guard::Notifier.notify(
        ::Guard::TestResultHelpers.summary(result) + "\n\n" + ::Guard::TestResultHelpers.duration(elapsed_time),
        :title => "Test::Unit results",
        :image => result.failure_count > 0 ? :failed : :success
      )
    end

  end
end
