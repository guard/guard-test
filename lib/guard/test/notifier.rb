# encoding: utf-8
require 'rubygems'
require 'guard'
require 'guard/guard'
require 'guard/notifier'

module Guard
  class Test < Guard
    module Notifier

      class << self
        def notify(result, elapsed_time)
          ::Guard::Notifier.notify(
            summary(result) + "\n\n" + duration(elapsed_time),
            :title => "Test::Unit results",
            :image => result.passed? ? :success : :failed
          )
        end

      private

        def summary(result)
          "#{result.run_count} test#{'s' if result.run_count != 1}, " +
          "#{result.assertion_count} assert#{'s' if result.assertion_count != 1}, " +
          "#{result.failure_count} fail#{'s' if result.failure_count != 1}, " +
          "#{result.error_count} error#{'s' if result.error_count != 1}"
        end

        def duration(duration, options = {})
          "Finished in #{round_float(duration)} seconds"
        end

        def round_float(float, decimals = 4)
          if Float.instance_method(:round).arity == 0 # Ruby 1.8
            factor = 10**decimals
            (float*factor).round / factor.to_f
          else # Ruby 1.9
            float.round(decimals)
          end
        end
      end

    end
  end
end