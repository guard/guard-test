guard 'rspec', :version => 2 do
  watch('^lib/(.*).rb')          { |m| "spec/#{m[1]}_spec.rb" }
  watch('^spec/(.*)_spec.rb')
  watch('^spec/spec_helper.rb')  { "spec" }
end

# This is for actually getting an example of the output of this guard
# All the tests under /test are fake ;)
guard 'test' do
  watch('^test/(.*)_test.rb')
  watch('^lib/(.*).rb')          { |m| "test/#{m[1]}_test.rb" }
  watch('^test/test_helper.rb')  { "test/unit" }
  watch('^test/test_helper.rb')  { "test/succeeding_test.rb" }
end