source 'https://rubygems.org'

gemspec

gem 'rake'

group :development do
  gem 'ruby_gntp'
  gem 'guard-rspec'
end

platforms :rbx do
  gem 'racc'
  gem 'rubysl', '~> 2.0'
  gem 'psych'
end

# The test group will be
# installed on Travis CI
#
group :test do
  gem 'codeclimate-test-reporter', group: :test, require: nil
end
