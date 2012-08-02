# Assets pipeline
# https://gist.github.com/3239413
require 'sprockets'
require 'sprockets-helpers'
require 'active_support/core_ext'

module Sinatra
  module AssetsPipeline
    # http://stackoverflow.com/a/10679994
    class Server

      attr_reader :app, :assets_prefix, :engine

      def initialize(app, options = {})
        app = app
        assets_prefix = options.delete(:prefix) || %r{/assets}
        engine = options.delete(:engine)
        yield engine if block_given?
      end

      def call(env)
        path = env['PATH_INFO']
        if path =~ assets_prefix
          env["PATH_INFO"].sub!(assets_prefix, '')
          engine.call(env)
        else
          app.call(env)
        end
      ensure
        env["PATH_INFO"] = path
      end
    end
    
    module Helpers
      include Sprockets::Helpers

      def stylesheet(*args)
        "<!-- TODO -->"
      end

      def javascript(*args)
        "<!-- TODO -->"
      end
    end

    def self.registered(app)
      # TODO: raise error if assets_path is not defined

      app.helpers Helpers

      app.set :sprockets, Sprockets::Environment.new(app.root)
      # Load all assets path
      app.assets_path.each do |path|
        app.sprockets.append_path File.join(app.root, path)
      end
      # Register asset pipeline middleware
      app.use Server, :engine => app.sprockets

      # Sprockets::Helpers.configure do |config|
      #   config.environment = app.sprockets
      #   config.manifest    = Sprockets::Manifest.new(app.sprockets, 'path/to/manifset.json')
      #   # config.prefix      = assets_prefix
      #   # config.public_path = public_folder
      # end
    end
  end
end

=begin
 
  # Sprockets
  set :assets, Sprockets::Environment.new(root)
  set :assets_prefix, if production? then 'http://cdn.hilios.com.br/assets' else 'assets' end

  configure do
    sprockets.append_path File.join(root, 'app/assets/stylesheets')
    sprockets.append_path File.join(root, 'app/assets/javascripts')
    sprockets.append_path File.join(root, 'app/assets/images')
    
  end

=end

=begin 

require "sprockets"
require "sinatra/base"

class SprocketsMiddleware
  attr_reader :app, :prefix, :sprockets

  def initialize(app, prefix)
    @app = app
    @prefix = prefix
    @sprockets = Sprockets::Environment.new

    yield sprockets if block_given?
  end

  def call(env)
    path_info = env["PATH_INFO"]
    if path_info =~ prefix
      env["PATH_INFO"].sub!(prefix, "")
      sprockets.call(env)
    else
      app.call(env)
    end
  ensure
    env["PATH_INFO"] = path_info
  end
end

class App < Sinatra::Base
  use SprocketsMiddleware, %r{/assets} do |env|
    env.append_path "assets/css"
    env.append_path "assets/js"
  end
end

App.run!

=end
