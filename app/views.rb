class Views < Hilios::Application::Base

  before do
    @blog = tumblr.blog_info(blog_name)['blog']
  end

  helpers do
    def post_per_page
      20.freeze
    end

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
    @page = request.params.delete('page').to_i || 0
    @posts = tumblr.posts(blog_name, {
      offset: @page * post_per_page
    })['posts']

    if request.xhr?
      partial :post, collection: @posts
    else
      slim :index
    end
  end

  # get '/search' do
  #   @posts = tumblr.posts(blog_name)['posts']
  #   slim :search
  # end

  get '/blog/:id/:slug' do |id, slug|
    @post = tumblr.posts(blog_name, {id: id})['posts'].first
    slim :read
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
    redirect 'http://twitter.com/hilios'
  end
end