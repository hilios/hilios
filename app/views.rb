class Views < Hilios::Frontend::Base

  helpers do
    def tumblr
      @tumblr ||= Tumblr::Client.new
    end

    def blog_name
      "hilios".freeze
    end

    def avatar(size=nil)
      @avatar ||= tumblr.avatar(blog_name, size)
    end

    def blog
      @blog ||= tumblr.blog_info(blog_name)['blog']
    end

    def posts
      @posts ||= tumblr.posts(blog_name)['posts']
    end

    def post(id)
      @post ||= tumblr.posts(blog_name, {id: id})['posts'].first
    end
  end

  get '/' do
    haml :index
  end

  get '/blog/:id/:slug' do |id, slug|
    @id = id
    haml :post
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