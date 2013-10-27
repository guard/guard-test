group :specs do
  guard :rspec, cmd: 'bundle exec rspec -f doc' do
    watch(%r{^(lib/.+)\.rb$})      { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb')   { "spec" }
  end
end

group :tests do
  guard :test do
    watch(%r{test/.+_test\.rb})
    watch('test/test_helper.rb') { "test" }
  end
end
