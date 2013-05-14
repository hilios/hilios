# encoding: UTF-8
class Views < Hilios::Frontend::Base

  before do
    @blog = tumblr.blog_info(blog_name)['blog']
  end

  helpers do
    def blog_name
      "hilios".freeze
    end

    def tumblr
      @tumblr ||= Tumblr::Client.new
    end

    def avatar(size=nil)
      tumblr.avatar(blog_name, size)
    end
  end

  get '/' do
    @posts = tumblr.posts(blog_name)['posts']
    slim :index
  end

  get '/blog/:id/:slug' do |id, slug|
    @post = tumblr.posts(blog_name, {id: id})['posts'].first
    slim :post
  end

  not_found do
    slim :not_found
  end

  get '/linkedin' do
    redirect 'http://www.linkedin.com/in/edsonhilios'
  end

  get '/github' do
    redirect 'https://github.com/hilios'
  end

  get '/twitter' do
    @post = {}
    redirect 'http://twitter.com/hilios'
  end
end