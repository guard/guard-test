module Guard
  class Test
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          clean_paths = paths.select { |p| test_file?(p) || test_folder?(p) }

          paths.each do |path|
            if File.directory?(path)
              clean_paths.delete(path)
              clean_paths = clean_paths + Dir.glob("#{path}/**/*_test.rb")
            end
          end

          clean_paths.uniq!
          clean_paths.compact!
          clear_test_files_list
          clean_paths.sort
        end

      private

        def test_folder?(path)
          path.match(/^\/?test/) && !path.match(/\..+$/)
        end

        def test_file?(path)
          test_files.include?(path)
        end

        def test_files
          @test_files ||= Dir.glob("test/**/*_test.rb")
        end

        def clear_test_files_list
          @test_files = nil
        end

      end
    end
  end
end
