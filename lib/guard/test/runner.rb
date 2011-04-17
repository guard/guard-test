module Guard
  class Test
    module Runner
      class << self

        def available_runners
          @available_runners ||= Dir.open(File.join(File.dirname(__FILE__), 'runners')).map do |filename|
            filename[/^(\w+)_test_unit_runner\.rb$/, 1]
          end.compact
        end

        def set_test_unit_runner(options={})
          @test_unit_runner = available_runners.include?(options[:runner]) ? options[:runner] : available_runners[0]
        end

        def run(paths, options={})
          message = options[:message] || "Running (#{@test_unit_runner} runner): #{paths.join(' ') }"
          UI.info(message, :reset => true)
          system(test_unit_command(paths, options))
        end

      private

        def bundler?
          @bundler ||= File.exist?("#{Dir.pwd}/Gemfile")
        end

        def test_unit_command(files, options={})
          cmd_parts = []
          cmd_parts << "rvm #{options[:rvm].join(',')} exec" if options[:rvm].respond_to?(:join)
          cmd_parts << "bundle exec" if bundler? && options[:bundler] != false
          cmd_parts << "ruby -rubygems"
          cmd_parts << "-r#{File.dirname(__FILE__)}/runners/#{@test_unit_runner}_test_unit_runner"
          cmd_parts << "-Ilib:test"
          cmd_parts << "-e \"%w[#{files.join(' ')}].each { |f| load f }\""
          cmd_parts << files.map { |f| "\"#{f}\"" }.join(' ')
          cmd_parts << "--runner=guard-#{@test_unit_runner}"
          cmd_parts.join(' ')
        end

      end
    end
  end
end
