# frozen_string_literal: true

require 'yard'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', '-', 'README.md', 'LICENSE.txt']
  t.options = ['--no-private']
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
