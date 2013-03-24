# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/test/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'http://rubygems.org/gems/guard-test'
  s.summary     = 'Guard gem for test-unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-test'

  s.add_dependency 'guard',     '>= 1.1'
  s.add_dependency 'test-unit', '~> 2.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec',   '~> 2.13'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
