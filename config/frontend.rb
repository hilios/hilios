require 'rubygems'
require 'bundler/setup'
# Webserver
require 'sinatra/base'
require 'sinatra/contrib/all'
require 'active_support/inflector'

module Hilios
  class Frontend < Sinatra::Base
    enable :logging, :dump_errors
    # Views configuration
    set :views, 'app/views'
    set :haml,  ugly: true,
                format: :html5, 
                layout: :'layouts/application'
    # Sessions
    enable :sessions
    set    :session_secret, '1Gikx4OTdoQp9OLjxfK76NBm065IzPkYTAirE8iUT5wgXAIW30dbjxOr5riSvRrKEQ7JxDsk7Kfz363Vif2erbgSZt3Xjh6hs8ZX8cO6X0ntzYYhgYzUmedQG8WielBh'
    # Assets pipeline

    # Helpers
    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
    end
    # Require all controllers as middlewares
    Dir["./app/controllers/**/*.rb"].each do |file_path|
      self.send :require, file_path
      # Predicts class name from file name, just like rails
      klass = File.basename(file_path, ".rb")
      klass = ActiveSupport::Inflector.camelize(klass)
      klass = ActiveSupport::Inflector.constantize(klass)
      # Use as a middleware
      use klass
    end
  end
end