source "http://rubygems.org"

# Specify your gem's dependencies in guard-test.gemspec
gemspec

if ENV["USE_GIT_REPOS"]
  gem 'guard', :git => "git://github.com/guard/guard.git"
end

gem 'rake'
gem 'turn'

require 'rbconfig'

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

