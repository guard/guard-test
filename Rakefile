require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = (ENV['CI'] == 'true')
end

task default: :spec
