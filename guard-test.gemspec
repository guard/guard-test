# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/test/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Guard gem for Test::Unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'
  s.author      = 'Rémy Coutable'
  s.email       = 'remy@rymai.me'
  s.homepage    = 'https://github.com/guard/guard-test'

  s.add_runtime_dependency 'guard',     '>= 1.8'
  s.add_runtime_dependency 'test-unit', '~> 2.2'

  s.add_development_dependency 'bundler', '>= 1.3'

  s.files = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
