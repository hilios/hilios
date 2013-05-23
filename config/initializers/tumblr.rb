require 'tumblr_client'

TUMBLR_KEY = File.expand_path('~/.tumblr')

if File.exists? TUMBLR_KEY
  TUMBLR_KEY = YAML::load(TUMBLR_KEY)
else
  raise "Tumblr API configuration not found at #{TUMBLR_KEY}"
end

Tumblr.configure do |config|
  config.consumer_key       = "t8mZzTpHohTFzSKasaJxWNkzJtA7chRKHSSPEiCwuaRYxrzqj5"
  config.consumer_secret    = "WcvO9DjYj3LWJmEHu483ZU7z84goV0bCo5WXARlDf6jLzP4wsy"
  config.oauth_token        = "RREvc3H0xxK1heEWjzMNswBxYzQsLIkvwyRQoJ8pqUzWzxpj23"
  config.oauth_token_secret = "qvgv1HjiXt99jzBlyS7weY9MlY9pp5Y1tbBLTALbA0KS7PfE5U"
end