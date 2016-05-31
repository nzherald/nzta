require 'dotenv'
require 'http'
require 'nokogiri'

module NZTA
  class Client
    attr_reader :http_client

    def initialize(options = {})
      Dotenv.load
      @username    = options.fetch(:username, ENV['NZTA_API_USERNAME'])
      @password    = options.fetch(:password, ENV['NZTA_API_PASSWORD'])
      @http_client = setup_http_client(options[:http_client])
    end

    def get_xml(url)
      resp = http_client.get url
      Nokogiri::XML(resp)
    end

    def traffic_conditions
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TrafficConditions2/REST/FeedService/'
    end

    def traffic_signs
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/VariableMessageSigns2/REST/FeedService/'
    end

    def traffic_cameras
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TrafficCameras2/REST/FeedService/'
    end

    def segments
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/SsdfJourney2/REST/FeedService/'
    end

    private

    def setup_http_client(http_client)
      return http_client.new(username: @username, password: @password) unless http_client.nil?
      HTTP[username: @username, password: @password]
    end
  end
end
