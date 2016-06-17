# basic Net::HTTP client
require 'uri'

module NZTA
  class BasicHTTPClient
    def initialize(options)
      @username = options.fetch(:username)
      @password = options.fetch(:password)
    end

    def get(url)
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)

      req['username'] = @username
      req['password'] = @password

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http| http.request(req)}
      res.body
    end
  end
end
