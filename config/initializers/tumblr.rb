require 'tumblr_client'

tumblr_config = File.expand_path('~/.tumblr')

if File.exists? tumblr_config
  tumblr_config = YAML::load_file(tumblr_config)
else
  raise "Tumblr API configuration not found at #{TUMBLR_KEY}"
end

Tumblr.configure do |config|
  config.consumer_key       = tumblr_config['consumer_key']
  config.consumer_secret    = tumblr_config['consumer_secret']
  config.oauth_token        = tumblr_config['oauth_token']
  config.oauth_token_secret = tumblr_config['oauth_token_secret']
end