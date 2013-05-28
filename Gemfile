source 'http://rubygems.org'

gem 'rake'

gem 'sinatra'                 # Webserver
gem 'sinatra-contrib'         # Sinatra helpers
gem 'sinatra-partial'         # Partial helper
gem 'sinatra-sprockets-chain' # Assets pipeline

gem 'activesupport'           # Dubious semantics and helper methods
gem 'unicorn'                 # Rack handler

gem 'tumblr_client'           # Tumblr API Client

gem 'slim'                    # HTML parser
gem 'redcarpet'               # Markdown parser

gem 'phantomjs',    require: false # Generate url screenshots
gem 'mini_magick',  require: false # Manipulate images

group :assets do
  gem 'sprockets-sass'
  gem 'therubyracer'            # Javascript evaluator
  gem 'coffee-script'           # Javascript compiler
  gem 'compass'                 # Stylesheet framework
end

group :development do
  gem 'shotgun'             # Auto reload Rack environment
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-unicorn'
  gem 'rvm-capistrano'
  gem 'capistrano_colors'
end