guard 'rspec' do
  watch('^spec/(.*)_spec.rb')
  watch('^lib/(.*)\.rb')        { "spec" }
  watch('^spec/spec_helper.rb') { "spec" }
end

guard 'test', :runner => 'fastfail' do
  watch('^test/(.*)_test.rb')
  watch('^lib/(.*)\.rb')        { "test" }
  watch('^test/test_helper.rb') { "test" }
end