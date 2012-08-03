# Assets pipeline
# https://gist.github.com/3239413
require 'sprockets'
require 'sprockets-helpers'

module Sinatra
  module AssetsPipeline
    # http://stackoverflow.com/a/10679994
    class Server

      attr_reader :app, :engine, :path_prefix

      def initialize(app, engine, path_prefix, &block)
        @app = app
        @engine = engine
        @path_prefix = path_prefix
        yield engine if block_given?
      end

      def call(env)
        path = env['PATH_INFO']
        if path =~ path_prefix and not engine.nil?
          env["PATH_INFO"].sub!(path_prefix, '')
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
        args.map! do |asset|
          asset = "#{asset}.css" if asset.is_a? Symbol
          "<link href='#{asset_path(asset)}' rel='stylesheet' type='text/css' />"
        end
        args.join("\n")
      end

      def javascript(*args)
        args.map! do |asset|
          asset = "#{asset}.js" if asset.is_a? Symbol
          "<script type='text/javascript' src='#{asset_path(asset)}'></script>"
        end
        args.join("\n")
      end
    end

    class << self
      # Class accessors
      attr_accessor :sprockets, :assets_prefix, :assets_path, :assets_host, :manifest_file

      def registered(app)
        sprockets ||= Sprockets::Environment.new(app.root)
        app.set :sprockets, sprockets
        assets_prefix     = get_setting app, :assets_prefix, default: '/assets'
        assets_path       = get_setting app, :assets_path
        assets_host       = get_setting app, :assets_host,   default: ''
        assets_precompile = get_setting app, :assets_precompile
        # Set the manifest file path
        app.set :assets_manifest_file, File.join(app.public_folder, assets_prefix, "manifset.json")
        # Load all assets path
        assets_path.each do |path|
          sprockets.append_path File.join(app.root, path)
        end
        # Register asset pipeline middleware
        app.use Server, app.sprockets, %r(#{assets_prefix})
        # Configure
        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.manifest    = Sprockets::Manifest.new(app.sprockets, app.assets_manifest_file)
          config.prefix      = app.assets_prefix
          config.public_path = app.public_folder
          config.digest      = true
        end
        # Add helpers
        app.helpers Helpers
      end
      # Get settings or fallback to defaults
      def get_setting(app, setting_name, options={})
        app.send(setting_name)
      rescue
        if (default = options.delete(:default))
          app.set setting_name, default
          retry
        else
          raise SettingNotFound, setting_name
        end
      end
    end

    class SettingNotFound < Exception; end
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
