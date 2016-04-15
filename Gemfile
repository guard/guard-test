source 'https://rubygems.org'

gemspec

gem 'rake'

group :development do
  gem 'ruby_gntp'
  gem 'guard-rspec'
end

# The test group will be
# installed on Travis CI
#
group :test do
  gem 'rspec', '~> 3.1'
  gem 'codeclimate-test-reporter', require: nil
end

platforms :rbx do
  gem 'racc'
  gem 'rubysl', '~> 2.0'
  gem 'psych'
end
