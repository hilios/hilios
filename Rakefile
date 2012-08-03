#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

def app
  require ::File.expand_path('../config/frontend',  __FILE__)
  Hilios::Frontend::Application
end

# task :default => :test

require 'rake/sprocketstask'
Rake::SprocketsTask.new do |t|
  t.environment = app.sprockets
  t.output      = File.join(app.public_folder, app.assets_prefix)
  t.assets      = app.assets_precompile
end

desc "Precompile assets"
namespace :assets do
  task :precompile => :assets
end

# require "rspec/core/rake_task"
# RSpec::Core::RakeTask.new(:spec) do |task|
#   task.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
#   task.pattern    = 'spec/**/*_spec.rb'
# end

# begin
#   require 'rdoc/task'
# rescue LoadError
#   require 'rdoc/rdoc'
#   require 'rake/rdoctask'
#   RDoc::Task = Rake::RDocTask
# end