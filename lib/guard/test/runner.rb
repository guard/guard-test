require "#{File.dirname(__FILE__)}/guard_test_unit_runner"

module Guard
  class Test
    module Runner
      class << self
        
        def run(paths, options = {})
          message = options[:message] || "Running: #{paths.join(' ') }"
          UI.info(message, :reset => true)
          system(test_unit_command(paths))
        end
        
      private
        
        def test_unit_command(files)
          cmd_parts = ["ruby -r#{File.dirname(__FILE__)}/guard_test_unit_runner -Itest"]
          cmd_parts << "-e \"%w[#{files.join(' ')}].each { |f| load f }\""
          cmd_parts << files.map { |f| "\"#{f}\"" }.join(' ')
          cmd_parts << '--runner=guard'
          cmd_parts.join(' ')
        end
        
      end
    end
  end
end