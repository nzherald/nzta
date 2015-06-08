module NZTA
  class Client
    def initialize(options)
      @username    = options.fetch(:username)
      @password    = options.fetch(:password)
      @http_client = setup_http_client(options[:http_client])
    end

    private

    def setup_http_client(http_client)
      return http_client.new(username: @username, password: @password) unless http_client.nil?
      HTTP[username: @username, password: @password]
    end
  end
end
