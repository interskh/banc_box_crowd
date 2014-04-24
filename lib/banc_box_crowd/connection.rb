module BancBoxCrowd
  class Connection

    def initialize
      @key = BancBoxCrowd::Config.api_key
      @secret = BancBoxCrowd::Config.api_secret
      @base_url = BancBoxCrowd::Config.base_url
    end

    # Perform an HTTP POST request
    def post(path, data={})
      request(:post, path, data)
    end

    private

    def request(method, path, data)
      data ||= {}
      data.merge!(authentication_data)
      response = faraday_connection.send(method) do |request|
        case method
        when :delete, :get
          request.url(path, params)
        when :post
          request.path = path
          request.body = data unless data.empty?
        end
      end
      response.body
    end

    def authentication_data
      { 
        'api_key' => BancBoxCrowd::Config.api_key,
        'secret' => BancBoxCrowd::Config.api_secret
      }
    end

    def faraday_connection
      options = {
        :url => @base_url,
        :ssl => {:verify => false}
      }

      @faraday_connection ||= Faraday::Connection.new(options) do |builder|
        builder.use Faraday::Request::UrlEncoded
        # builder.use Faraday::Request::Multipart
        builder.use FaradayMiddleware::EncodeJson
        builder.use FaradayMiddleware::ParseJson
        # builder.use FaradayMiddleware::Mashify
        builder.adapter Faraday.default_adapter
      end
    end
  end
end