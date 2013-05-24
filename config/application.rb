require 'rubygems'
require 'bundler/setup'
# Webserver
require 'slim'
require 'redcarpet'
require 'sinatra/base'
require 'sinatra/partial'
require 'sinatra/contrib/all'
require 'sinatra/sprockets'
require 'active_support/inflector'

Dir["./config/initializers/**/*.rb"].each { |f| require f }

module Hilios
  module Application
    # == Default configuration for the middlewares
    class Base < Sinatra::Base
      enable :logging, :dump_errors
      # Root
      set :root,  File.expand_path('../', File.dirname(__FILE__))
      # Views configuration
      set :views, 'app/templates'
      set :slim,  layout: :'layouts/application'
      # Sessions
      enable :sessions
      set    :session_secret, '1Gikx4OTdoQp9OLjxfK76NBm065IzPkYTAirE8iUT5wgXAIW30dbjxOr5riSvRrKEQ7JxDsk7Kfz363Vif2erbgSZt3Xjh6hs8ZX8cO6X0ntzYYhgYzUmedQG8WielBh'
      # Assets pipeline
      set :assets_path, %w(app/assets/vendor app/assets/stylesheets app/assets/javascripts app/assets/images)
      set :assets_precompile, %w(application.js application.css *.svg *.ttf)
      # Extensions
      register Sinatra::Contrib
      register Sinatra::Partial
      register Sinatra::Sprockets
      # Helpers
      helpers do
        include Rack::Utils
        alias_method :h, :escape_html
      end

      configure do
        # Partial helper
        set :partial_template_engine, :slim
        enable :partial_underscores
      end
    end

    class Boot < Base
      # Middlewares
      use Rack::Session::Pool, :expire_after => 2592000
      use Rack::ShowExceptions
      # Require all controller as middlewares
      Dir["./app/**/*.rb"].each do |file_path|
        require file_path
        # Predicts class name from file name, just like rails
        klass = File.basename(file_path, ".rb")
        klass = ActiveSupport::Inflector.camelize(klass)
        klass = ActiveSupport::Inflector.constantize(klass)
        # Use as a middleware
        use klass
      end
    end
  end
end