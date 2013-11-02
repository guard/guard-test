module Guard
  class Test
    module Inspector

      class << self
        def test_paths
          @test_paths || []
        end

        def test_paths=(path_array)
          @test_paths = Array(path_array)
        end

        def clean(paths)
          paths.uniq!
          paths.compact!

          paths.dup.each do |path|
            if test_folder?(path)
              paths.delete(path)
              paths += check_test_files(path)
            else
              paths.delete(path) unless test_file?(path)
            end
          end

          paths.uniq!
          paths.compact!
          clear_test_files_list
          paths.sort - ['test/test_helper.rb']
        end

      private

        def test_folder?(path)
          paths = test_paths.join("|")
          path.match(%r{^\/?(#{paths})}) && !path.match(/\..+$/) && File.directory?(path)
        end

        def test_file?(path)
          test_files.include?(path)
        end

        def test_files
          @test_files ||= test_paths.collect { |path| check_test_files(path) }.flatten
        end

        def clear_test_files_list
          @test_files = nil
        end

        def check_test_files(path)
          Dir[File.join(path, '**', 'test_*.rb')] +
          Dir[File.join(path, '**', '*_test{s,}.rb')]
        end
      end

    end
  end
end
