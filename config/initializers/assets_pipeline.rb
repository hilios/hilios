# Assets pipeline
# https://gist.github.com/3239413
require 'sprockets'
require 'sprockets-helpers'

module Sinatra
  module AssetsPipeline
    # http://stackoverflow.com/a/10679994
    class Server
      attr_reader :app, :root, :assets_prefix, :precompile, :sprockets

      def initialize(app, options = {})
        @app = app
        @root = options.delete(:root)
        # @precompile = [*options.delete(:precompile)]
        @assets_prefix = options.delete(:prefix) || %r{/assets}
        @sprockets = if root
          Sprockets::Environment.new(root)
        else
          Sprockets::Environment.new
        end
        yield sprockets if block_given?
      end

      def call(env)
        path = env['PATH_INFO']
        if path =~ assets_prefix
          env["PATH_INFO"].sub!(assets_prefix, '')
          sprockets.call(env)
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

      app.use Server, :root => app.root do |sprockets|
        app.assets_path.each do |path|
          sprockets.append_path File.join(app.root, path)
        end
      end
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
