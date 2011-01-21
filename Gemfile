source "http://rubygems.org"

gemspec

if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '~> 0.3.9'
  gem 'growl',      '~> 1.0.3'
end
if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '~> 0.8.4'
  gem 'libnotify',  '~> 0.3.0'
end
