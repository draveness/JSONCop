# require "bundler/gem_tasks"
# require "rspec/core/rake_task"
require_relative 'lib/jsoncop/version'

require "pathname"

# RSpec::Core::RakeTask.new(:spec)

task :default => [:build, :install, :clean]

task :release => [:build, :push, :clean]

task :push do
  system %(gem push #{build_product_file})
end

task :build do
  system %(gem build jsoncop.gemspec)
end

task :install do
  system %(gem install #{build_product_file})
end

task :clean do
  system %(rm *.gem)
end

def build_product_file
  "jsoncop-#{JSONCop::VERSION}.gem"
end
