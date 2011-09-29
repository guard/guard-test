source "http://rubygems.org"

# Specify your gem's dependencies in guard-test.gemspec
gemspec

gem 'rake'
gem 'guard',       :git => "git://github.com/guard/guard.git"
gem 'guard-rspec', :git => "git://github.com/guard/guard-rspec.git"

require 'rbconfig'

platforms :ruby do
  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent'
    gem 'growl'
  elsif Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify',  '~> 0.1.3'
  end
end

platforms :jruby do
  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'growl'
  elsif Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify',  '~> 0.1.3'
  end
end
