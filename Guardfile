group :specs, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec', failed_mode: :keep do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end
end

group :tests do
  guard :test do
    watch(%r{test/.+_test\.rb})
    watch('test/test_helper.rb') { "test" }
  end
end
