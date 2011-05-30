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
          :notify   => true,
          :bundler  => File.exist?("#{Dir.pwd}/Gemfile"),
          :rvm      => nil,
          :verbose  => false,
          :use_turn => false
        }.merge(options)

        if @options[:use_turn]
          begin
            require 'turn'
          rescue LoadError
            ::Guard::UI.error("turn could not be required, fallbacking to normal ruby.", :reset => true)
            @options[:use_turn] = false
          end
        end
      end

      def run(paths, options={})
        return true if paths.empty?

        message = options[:message] || "Running (#{@runner_name} runner): #{paths.join(' ') }"
        ::Guard::UI.info(message, :reset => true)
        system(test_unit_command(paths))
      end

      def rvm?
        @options[:rvm] && @options[:rvm].respond_to?(:join)
      end

    private

      def test_unit_command(paths)
        cmd_parts = []
        cmd_parts << "rvm #{@options[:rvm].join(',')} exec" if rvm?
        cmd_parts << "bundle exec" if @options[:bundler]
        cmd_parts << "#{@options[:use_turn] ? 'turn' : 'ruby'} -Itest -rubygems"
        cmd_parts << "-r bundler/setup" if @options[:bundler]
        cmd_parts << "-r #{File.expand_path("../runners/#{@runner_name}_guard_test_runner", __FILE__)}" unless @options[:use_turn]
        cmd_parts << "-e \"%w[#{paths.join(' ')}].each { |path| load path }; GUARD_TEST_NOTIFY=#{@options[:notify]}\"" unless @options[:use_turn]
        cmd_parts << paths.map { |path| "\"#{path}\"" }.join(' ')
        cmd_parts << "--runner=guard-#{@runner_name}" unless @options[:use_turn]
        cmd_parts << "--verbose" if @options[:verbose]

        cmd_parts.join(' ')
      end

    end
  end
end
