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

    def traffic_conditions
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TrafficConditions2/REST/FeedService/'
    end

    def traffic_signs
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/VariableMessageSigns2/REST/FeedService/'
    end

    def traffic_cameras
      get_xml 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/TrafficCameras2/REST/FeedService/'
    end

    def segments(id = nil)
      process_segments(get_segments(id))
    end

    def generate_segment_map(id = nil)
      map_segments(get_segments(id))
    end

    private

    def get_xml(url)
      resp = http_client.get url
      Nokogiri::XML(resp).remove_namespaces!
    end

    def get_segments(id = nil)
      url = 'https://infoconnect1.highwayinfo.govt.nz/ic/jbi/SsdfJourney2/REST/FeedService/'

      url = url + "segments?type=#{id}" if id
      get_xml(url).css('return')
    end

    def map_segments(segments)
      segments.map do |segment|
        {
          id: segment.css('id').text,
          name: segment.css('sectionName').text,
          sectionLength: segment.css('sectionLength').text,
          type: {
            groupType: segment.css('segmentType groupType').text,
            id: segment.css('segmentType id').text,
            name: segment.css('segmentType name').text
          },
          start: {
            latitude: segment.css('startLocation latitude').text,
            longitude: segment.css('startLocation longitude').text,
            speedLimit: segment.css('startLocation speedLimit').text
          },
          end: {
            latitude: segment.css('endLocation latitude').text,
            longitude: segment.css('endLocation longitude').text,
            speedLimit: segment.css('endLocation speedLimit').text
          }
        }
      end
    end

    def process_segments(segments)
      segments.map do |segment|
        {
          id: segment.css('id').text,
          averageOccupancy: segment.css('averageOccupancy').text,
          averageSpeed: segment.css('averageSpeed').text,
          carriagewaySegmentId: segment.css('carriagewaySegmentId').text,
          defaultSpeed: segment.css('defaultSpeed').text,
          lastReadingTime: segment.css('lastReadingTime').text,
          reliability: segment.css('reliability').text,
          sectionTime: segment.css('sectionTime').text,
          sectionName: segment.css('sectionName').text
        }
      end
    end

    def setup_http_client(http_client)
      return http_client.new(username: @username, password: @password) unless http_client.nil?
      HTTP[username: @username, password: @password]
    end
  end
end
