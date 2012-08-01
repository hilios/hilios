class Index < Hilios::Frontend::Base
  get '/' do
    haml :index
  end

  get '/blog' do
    redirect 'http://hilios.tumblr.com'
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

  get '/facebook' do
    redirect 'http://www.facebook.com/hilios'
  end
end