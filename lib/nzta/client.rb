require 'dotenv'
require 'http'
require 'nokogiri'

module NZTA
  class Client
    attr_reader :http_client

    def initialize(options = {})
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

    def segment_geojson(id = nil)
      segments = generate_segment_map(id)

      features = segments.map {|segment| parse_segment_geojson(segment) }

      {
        type: 'FeatureCollection',
        features: features
      }
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
          section_length: segment.css('sectionLength').text.to_f,
          type: {
            group: segment.css('segmentType groupType').text,
            id: segment.css('segmentType id').text,
            name: segment.css('segmentType name').text
          },
          start: {
            latitude: segment.css('startLocation latitude').text.to_f,
            longitude: segment.css('startLocation longitude').text.to_f,
            speed_limit: segment.css('startLocation speedLimit').text.to_i
          },
          end: {
            latitude: segment.css('endLocation latitude').text.to_f,
            longitude: segment.css('endLocation longitude').text.to_f,
            speed_limit: segment.css('endLocation speedLimit').text.to_i
          }
        }
      end
    end


    def parse_segment_geojson(segment)
      {
        type: 'Feature',
        geometry: {
          type: 'LineString',
          coordinates: [
            [ segment[:start][:latitude], segment[:start][:longitude] ],
            [ segment[:end][:latitude], segment[:end][:longitude] ]
          ]
        },
        properties: {
          id: segment[:id],
          name: segment[:name],
          length: segment[:section_length],
          startSpeedLimit: segment[:start][:speed_limit],
          endSpeedLimit: segment[:end][:speed_limit],
          type: segment[:type][:name]
        }
      }
    end

    def process_segments(segments)
      segments.map do |segment|
        {
          id: segment.css('id').text,
          average_occupancy: segment.css('averageOccupancy').text,
          average_speed: segment.css('averageSpeed').text,
          carriageway_segment_id: segment.css('carriagewaySegmentId').text,
          default_speed: segment.css('defaultSpeed').text,
          last_reading_time: segment.css('lastReadingTime').text,
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
