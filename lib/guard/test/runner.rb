require 'guard/compat/plugin'

module Guard
  class Test < Plugin
    class Runner

      attr_reader :options

      def initialize(opts = {})
        @options = {
          bundler:  File.exist?("#{Dir.pwd}/Gemfile"),
          rubygems: false,
          rvm:      [],
          include:  %w[lib:test],
          drb:      false,
          zeus:     false,
          spring:   false,
          cli:      ''
        }.merge(opts)
      end

      def run(paths, opts = {})
        return true if paths.empty?

        Compat::UI.info(opts[:message] || "Running: #{paths.join(' ')}", reset: true)

        system(test_unit_command(paths))
      end

      def bundler?
        if @bundler.nil?
          @bundler = options[:bundler] && !drb? && !zeus? && !spring?
        end
        @bundler
      end

      def rubygems?
        !bundler? && !zeus? && !spring? && options[:rubygems]
      end

      def drb?
        if @drb.nil?
          @drb = options[:drb]
          begin
            require 'spork-testunit'
          rescue LoadError
          end
          Compat::UI.info('Using testdrb to run the tests') if @drb
        end
        @drb
      end

      def zeus?
        if @zeus.nil?
          @zeus = options[:zeus]
          Compat::UI.info('Using zeus to run the tests') if @zeus
        end
        @zeus
      end

      def spring?
        if @spring.nil?
          @spring = options[:spring]
          Compat::UI.info('Using spring to run the tests') if @spring
        end
        @spring
      end

    private

      def test_unit_command(paths)
        cmd_parts = executables
        cmd_parts.concat(includes_and_requires(paths))
        cmd_parts.concat(command_options)
        cmd_parts << options[:cli]

        cmd_parts.compact.join(' ').strip
      end

      def executables
        parts = []
        parts << "rvm #{options[:rvm].join(',')} exec" unless options[:rvm].empty?
        parts << 'bundle exec' if bundler?
        parts << case true
                 when drb? then 'testdrb'
                 when zeus? then 'zeus test'
                 when spring? then spring_command
                 else 'ruby'; end
      end

      def spring_command
        if Gem.loaded_specs["rails"] && Gem.loaded_specs["rails"].version < Gem::Version.create('4.0')
          'spring testunit'
        else
          # rails > 4.0 supports passing a path to rake test
          'spring rake test'
        end
      end

      def includes_and_requires(paths)
        parts = []
        parts << Array(options[:include]).map { |path| "-I\"#{path}\"" } unless zeus? || spring?
        parts << paths if zeus? || spring? || drb?
        parts << '-r bundler/setup' if bundler?
        parts << '-r rubygems' if rubygems?

        unless drb? || zeus? || spring?
          parts << "-r #{File.expand_path("../guard_test_runner", __FILE__)}"
          parts << "-e \"%w[#{paths.join(' ')}].each { |p| load p }\""
        end

        parts
      end

      def command_options
        if drb? || zeus? || spring?
          []
        else
          ['--', '--color']
        end
      end

    end
  end
end
