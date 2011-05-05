# encoding: utf-8
module Guard
  class Test
    class Runner

      class << self
        def runners
          @runners ||= Dir.open(File.join(File.dirname(__FILE__), 'runners')).map do |filename|
            filename[/^(\w+)_guard_test_runner\.rb$/, 1]
          end.compact
        end

        def run(paths=[], options={})
          Runner.new(options).run(paths, options)
        end
      end

      def initialize(options={})
        @runner  = self.class.runners.detect { |runner| runner == options[:runner] } || self.class.runners[0]
        @options = {
          :notify  => true,
          :bundler => File.exist?("#{Dir.pwd}/Gemfile"),
          :rvm     => nil,
          :verbose => false
        }.merge(options)
      end

      def run(paths, options={})
        message = options[:message] || "Running (#{@runner} runner): #{paths.join(' ') }"
        ::Guard::UI.info(message, :reset => true)
        system(test_unit_command(paths))
      end

      def notify?
        @options[:notify]
      end

      def bundler?
        @options[:bundler]
      end

      def rvm?
        @options[:rvm] && @options[:rvm].respond_to?(:join)
      end

      def verbose?
        @options[:verbose]
      end

      private

      def test_unit_command(paths)
        cmd_parts = []
        cmd_parts << "rvm #{@options[:rvm].join(',')} exec" if rvm?
        cmd_parts << "bundle exec" if bundler?
        cmd_parts << "ruby -Itest -rubygems"
        cmd_parts << "-r bundler/setup" if bundler?
        cmd_parts << "-r #{File.dirname(__FILE__)}/runners/#{@runner}_guard_test_runner"
        cmd_parts << "-e \"%w[#{paths.join(' ')}].each { |path| load path }; GUARD_TEST_NOTIFY=#{notify?}\""
        cmd_parts << paths.map { |path| "\"#{path}\"" }.join(' ')
        cmd_parts << "--runner=guard-#{@runner}"
        cmd_parts << "--verbose" if verbose?

        cmd_parts.join(' ')
      end

    end
  end
end
