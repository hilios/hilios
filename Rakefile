#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

def app
  require ::File.expand_path('../config/application',  __FILE__)
  Hilios::Application::Rack
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

desc "Generates a screenshot from an URL with 640x480px"
task :screenshot, :url, :path do |task, arguments|
  require 'phantomjs'
  require 'mini_magick'
  # Set the variables
  url = arguments[:url]
  path = arguments[:path]
  # Ensure path exists
  path_folder = File.expand_path(File.dirname(path))
  FileUtils.mkdir_p(path_folder) if not File.exists?(path_folder)
  # Generate the screenshot
  rasterize_path = File.expand_path('app/rasterize.js', File.dirname(__FILE__))
  Phantomjs.run(rasterize_path, url, path)
  # Resize image
  image = MiniMagick::Image.new(path)
  image.resize('640x')
  image.crop('x480!+0+0')
end

desc "Fetch blog links and take a screenshot"
task :take_screenshots, :page do |task, args|
  args.with_defaults(page: 0)

  require 'tumblr_client'
  require './config/screenshots.rb'
  require './config/initializers/tumblr.rb'

  tumblr = Tumblr::Client.new
  posts = tumblr.posts('hilios', {
    type: 'link', limit: 20, offset: args[:page].to_i * 20
  })['posts']

  puts posts.length

  for post in posts
    file_path = Screenshots.path_for(post['url'])
    full_path = File.join File.dirname(__FILE__), 'public', file_path
    if not File.exists? full_path
      puts "Generating screenshot for: #{post['url']}"
      Rake::Task["screenshot"].invoke(post['url'], full_path)
      Rake::Task["screenshot"].reenable
    end
  end
  
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