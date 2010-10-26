module Guard
  class Test
    module Runner
      class << self
        attr_reader :test_unit_runner
        
        AVAILABLE_TEST_UNIT_RUNNERS = %w[default fastfail]
        
        def set_test_unit_runner(options = {})
          @test_unit_runner = AVAILABLE_TEST_UNIT_RUNNERS.include?(options[:runner]) ? options[:runner] : 'default'
        end
        
        def run(paths, options = {})
          message = "\n" + (options[:message] || "Running (#{@test_unit_runner} runner): #{paths.join(' ') }")
          UI.info(message, :reset => true)
          system(test_unit_command(paths))
        end
        
      private
        
        def test_unit_command(files)
          cmd_parts = ["ruby -rubygems"]
          cmd_parts << "-r#{File.dirname(__FILE__)}/runners/#{@test_unit_runner}_test_unit_runner"
          cmd_parts << "-Itest"
          cmd_parts << "-e \"%w[#{files.join(' ')}].each { |f| load f }\""
          cmd_parts << files.map { |f| "\"#{f}\"" }.join(' ')
          cmd_parts << "--runner=guard-#{@test_unit_runner}"
          cmd_parts.join(' ')
        end
        
      end
    end
  end
end