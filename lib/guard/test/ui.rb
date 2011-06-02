# encoding: utf-8
require 'guard/test/result_helpers'

module Guard
  module TestUI

    COLOR_CODES = { :pass => ';32', :failure => ';31', :error => ';33', :reset => '' }

    class << self
      def results(result, elapsed_time, options={})
        color_puts(::Guard::TestResultHelpers.duration(elapsed_time, options))

        color = (result.failure_count > 0 ? :failure : (result.error_count > 0 ? :error : :pass))
        color_puts(::Guard::TestResultHelpers.summary(result), :color => color)
      end

      def color_print(text, options={})
        opts = { :color => :reset }.merge(options)

        $stdout.write("%s%s%s" % [color_sequence(opts[:color]), text, color_sequence(:reset)])
        $stdout.flush
        true
      end

      def color_puts(text, options={})
        color_print(text, options)
        $stdout.puts
      end

    private

      def color_sequence(color_name)
        "\e[0#{COLOR_CODES[color_name.to_sym]}m"
      end
    end

  end
end
