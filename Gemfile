source "http://rubygems.org"

# Specify your gem's dependencies in guard-test.gemspec
gemspec

gem 'guard',       :git => "git://github.com/guard/guard.git"
gem 'guard-rspec', :git => "git://github.com/guard/guard-rspec.git"

# rake 0.9 is not valid under ruby 1.8
if RUBY_VERSION >= '1.9'
  gem 'rake'
else
  gem 'rake', '0.8.7'
end

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
