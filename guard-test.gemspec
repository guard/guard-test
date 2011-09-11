# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/test/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Rémy Coutable']
  s.email       = ['rymai@rymai.me']
  s.homepage    = 'https://github.com/guard/guard-test'
  s.summary     = 'Guard gem for test-unit 2'
  s.description = 'Guard::Test automatically run your tests on file modification.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-test'

  s.add_dependency 'guard',     '>= 0.4.0'
  s.add_dependency 'test-unit', '~> 2.3.1'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec',   '~> 2.6'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
