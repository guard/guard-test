# encoding: utf-8
module Guard
  class Test
    module Inspector

      class << self
        def clean(paths)
          paths.uniq!
          paths.compact!

          paths.dup.each do |path|
            if test_folder?(path)
              paths.delete(path)
              paths += Dir.glob("#{path}/**/test_*.rb") + Dir.glob("#{path}/**/*_test.rb")
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
          path.match(/^\/?test/) && !path.match(/\..+$/) && File.directory?(path)
        end

        def test_file?(path)
          test_files.include?(path)
        end

        def test_files
          @test_files ||= Dir.glob('test/**/test_*.rb') + Dir.glob('test/**/*_test.rb')
        end

        def clear_test_files_list
          @test_files = nil
        end
      end

    end
  end
end
