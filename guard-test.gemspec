# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'guard/test/version'

Gem::Specification.new do |s|
  s.name        = 'guard-test'
  s.version     = Guard::TestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Rémy Coutable']
  s.email       = ['rymai@rymai.com']
  s.homepage    = 'http://rubygems.org/gems/guard-test'
  s.summary     = 'Guard gem for Test::Unit'
  s.description = 'Guard::Test automatically run your tests and notify you of the result when a file is modified.'
  
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-test'
  
  s.add_dependency 'guard',     '>= 0.2'
  s.add_dependency 'test-unit', '~> 2.1'
  
  s.add_development_dependency 'bundler',     '>= 1.0'
  s.add_development_dependency 'guard-rspec', '>= 0.1'
  s.add_development_dependency 'rspec',       '>= 2.1'
  
  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'
  
  s.rdoc_options = ["--charset=UTF-8", "--main=README.rdoc", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
end