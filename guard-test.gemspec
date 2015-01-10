$:.push File.expand_path('../lib', __FILE__)
require 'guard/test/version'

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.author      = 'Rémy Coutable'
  s.email       = 'remy@rymai.me'
  s.homepage    = 'https://rubygems.org/gems/guard-test'
  s.summary     = 'Guard plugin for Test::Unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'guard',     '~> 2.11'
  s.add_runtime_dependency 'test-unit', '~> 2.2'
  s.add_runtime_dependency 'guard-compat', '~> 1.2'

  s.add_development_dependency 'rspec', '~> 3.1'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
