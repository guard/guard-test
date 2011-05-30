source "http://rubygems.org"

# Specify your gem's dependencies in guard-test.gemspec
gemspec

require 'rbconfig'

library_path = File.expand_path("../../../guard", __FILE__)
if File.exist?(library_path)
  gem 'guard', :path => library_path
elsif ENV["USE_GIT_REPOS"]
  gem 'guard', :git => "git://github.com/guard/guard.git"
end

platforms :ruby do
  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.3.9'
    gem 'growl',      '~> 1.0.3' if ENV["GUARD_NOTIFY"] != 'false'
  end
  if Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify',  '~> 0.1.3' if ENV["GUARD_NOTIFY"] != 'false'
  end
end

platforms :jruby do
  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'growl',      '~> 1.0.3' if ENV["GUARD_NOTIFY"] != 'false'
  end
  if Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify',  '~> 0.1.3' if ENV["GUARD_NOTIFY"] != 'false'
  end
end

gem 'turn'
