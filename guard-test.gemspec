# encoding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)
require 'guard/test/version'

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Rémy Coutable'
  s.email       = 'remy@rymai.me'
  s.homepage    = 'https://github.com/guard/guard-test'
  s.summary     = 'Guard gem for Test::Unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'

  s.add_runtime_dependency 'guard',     '>= 1.8'
  s.add_runtime_dependency 'test-unit', '~> 2.2'

  s.add_development_dependency 'bundler'

  s.files = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
