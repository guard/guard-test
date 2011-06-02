# encoding: utf-8
module Guard
  class Test
    class Runner

      def self.runners
        @runners ||= Dir.open(File.expand_path('../runners', __FILE__)).map { |filename| filename[/^(\w+)_guard_test_runner\.rb$/, 1] }.compact
      end

      def initialize(options={})
        @runner_name = self.class.runners.detect { |runner| runner == options[:runner] } || self.class.runners[0]
        @options     = {
          :notification => true,
          :bundler      => File.exist?("#{Dir.pwd}/Gemfile"),
          :rvm          => nil,
          :cli          => nil
        }.merge(options)
      end

      def run(paths, options={})
        return true if paths.empty?

        message = options[:message] || "Running (#{@runner_name} runner): #{paths.join(' ') }"
        ::Guard::UI.info(message, :reset => true)
        system(test_unit_command(paths))
      end

      def rvm?
        @rvm ||= @options[:rvm] && @options[:rvm].respond_to?(:join)
      end

      def turn?
        @turn ||= Object.const_defined?('Turn')
      end

    private

      def test_unit_command(paths)
        cmd_parts = []
        cmd_parts << "rvm #{@options[:rvm].join(',')} exec" if rvm?
        cmd_parts << "bundle exec" if @options[:bundler]
        cmd_parts << "#{turn? ? 'turn' : 'ruby'} -Itest -rubygems"
        cmd_parts << "-r bundler/setup" if @options[:bundler]

        unless turn?
          cmd_parts << "-r #{File.expand_path("../runners/#{@runner_name}_guard_test_runner", __FILE__)}"
          cmd_parts << "-e \"GUARD_TEST_NOTIFY=#{@options[:notification]}\""
        end

        paths.each { |path| cmd_parts << "-r ./#{path}" }
        cmd_parts << "--"
        cmd_parts << "--runner=guard-#{@runner_name}" unless turn?
        cmd_parts << @options[:cli] if @options[:cli]

        cmd_parts.join(' ')
      end

    end
  end
end
