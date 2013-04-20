# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/test/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.summary     = 'Guard gem for Test::Unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'
  s.authors     = ['Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'http://rubygems.org/gems/guard-test'

  s.files = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]

  s.add_dependency 'guard',     '~> 1.8'
  s.add_dependency 'test-unit', '~> 2.2'

  s.add_development_dependency 'bundler', '~> 1.3'

  s.require_path = 'lib'
end
