require 'rubygems'
require 'bundler/setup'

Bundler.require
# Webserver
require 'sinatra/base'
require 'sinatra/contrib/all'
require 'sinatra/assetpack'
require 'active_support/inflector'

module Hilios
  module Frontend
    # == Default configuration for the middlewares
    class Base < Sinatra::Base
      enable :logging, :dump_errors
      # Root
      set :root, File.expand_path('../', File.dirname(__FILE__))

      # raise root
      # Views configuration
      set :views, 'app/views'
      set :haml,  ugly: production?,
                  format: :html5, 
                  layout: :'layouts/application'
      # Sessions
      enable :sessions
      set    :session_secret, '1Gikx4OTdoQp9OLjxfK76NBm065IzPkYTAirE8iUT5wgXAIW30dbjxOr5riSvRrKEQ7JxDsk7Kfz363Vif2erbgSZt3Xjh6hs8ZX8cO6X0ntzYYhgYzUmedQG8WielBh'
      # Extensions
      register Sinatra::Contrib
      register Sinatra::AssetPack
      # Configure assets pipeline
      assets do
        clear_ignores!
        
        serve '/assets', from: 'app/assets/javascripts'
        serve '/assets', from: 'app/assets/stylesheets'
        serve '/assets', from: 'app/assets/images'

        js  :main, ['/assets/**/*.js']
        css :main, ['/assets/frontend.css']

        # prebuild true
      end
      # Helpers
      helpers do
        include Rack::Utils
        alias_method :h, :escape_html

        alias_method :stylesheet, :css
        alias_method :javascript, :js
      end
    end

    class Application < Base
      # Middlewares
      use Rack::Session::Pool, :expire_after => 2592000
      use Rack::ShowExceptions
      # Require all controller as middlewares
      Dir["./app/controllers/**/*.rb"].each do |file_path|
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