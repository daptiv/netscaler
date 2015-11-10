require 'foodcritic'
require 'rspec/core/rake_task'

task :default => [:rubocop, :foodcritic, :spec]

task :rubocop do
  sh "bundle exec rubocop recipes/* attributes/*"
end

task :foodcritic do
  sh "bundle exec foodcritic attributes/* recipes/* resources/* providers/* libraries/*"
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '-f documentation', '-tunit']
end
