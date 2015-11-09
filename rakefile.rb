require 'foodcritic'
require 'rspec/core/rake_task'

task :default => [:version, :rubocop, :foodcritic, :spec]

task :version do
  IO.write('version.txt', (ENV['BUILD_NUMBER'] ? "0.0.#{ENV['BUILD_NUMBER']}" : '0.0.1'))
end

task :foodcritic do
  sh "bundle exec foodcritic attributes/* recipes/* resources/* providers/* libraries/*"
end

task :rubocop do
  sh "bundle exec rubocop recipes/* attributes/*"
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '-f documentation', '-tunit']
end
