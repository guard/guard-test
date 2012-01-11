# encoding: utf-8

module Guard
  class Test
    class Runner

      def initialize(options = {})
        @options = {
          :bundler  => File.exist?("#{Dir.pwd}/Gemfile"),
          :rubygems => false,
          :rvm      => [],
          :drb      => false,
          :cli      => ""
        }.merge(options)
      end

      def run(paths, options = {})
        return true if paths.empty?

        ::Guard::UI.info(options[:message] || "Running: #{paths.join(' ')}", :reset => true)

        system(test_unit_command(paths))
      end

      def bundler?
        if @bundler.nil?
          @bundler = @options[:bundler] && !drb?
        end
        @bundler
      end

      def rubygems?
        !bundler? && @options[:rubygems]
      end

      def drb?
        if @drb.nil?
          @drb = @options[:drb]
          begin
            require 'spork-testunit'
          rescue LoadError
          end
          ::Guard::UI.info("Using testdrb to run the tests") if @drb
        end
        @drb
      end

    private

      def test_unit_command(paths)
        cmd_parts = []
        cmd_parts << "rvm #{@options[:rvm].join(',')} exec" unless @options[:rvm].empty?
        cmd_parts << "bundle exec" if bundler?
        cmd_parts << case true
                     when drb?
                       "testdrb"
                     else
                       "ruby"
                     end
        cmd_parts << "-Itest"
        cmd_parts << "-r bundler/setup" if bundler?
        cmd_parts << "-rubygems" if rubygems?

        unless drb?
          cmd_parts << "-r #{File.expand_path("../guard_test_runner", __FILE__)}"
          cmd_parts << "-e \"%w[#{paths.join(' ')}].each { |p| load p }\""
        end

        paths.each { |path| cmd_parts << "\"./#{path}\"" }

        unless drb?
          cmd_parts << "--use-color"
          cmd_parts << "--runner=guard"
        end

        cmd_parts << @options[:cli]

        cmd_parts.compact.join(' ').strip
      end

    end
  end
end
