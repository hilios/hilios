#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Rakefile
APP_FILE  = ::File.expand_path('../config/frontend',  __FILE__)
APP_CLASS = 'Hilios::Frontend::Application'

task :frontend do
  require APP_FILE
end

require 'sinatra/assetpack/rake'

namespace :assets do
  task :precompile do
    Rake::Task['assetpack:build'].invoke
  end
end

# begin
#   require 'rdoc/task'
# rescue LoadError
#   require 'rdoc/rdoc'
#   require 'rake/rdoctask'
#   RDoc::Task = Rake::RDocTask
# end