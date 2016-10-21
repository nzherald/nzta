# NZTA

Work in Progress

You will need to request an API username and password from NZTA by completing this
form:

https://www.nzta.govt.nz/traffic-and-travel-information/infoconnect-section-page/infoconnect-access/


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nzta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nzta

## Usage

Either set environment variables `NZTA_API_USERNAME` and `NZTA_API_PASSWORD` and initialize the client with no arguments:

```ruby
  client = NZTA::Client.new
```

or pass them through to the initialiser:

```ruby
  client = NZTA::Client.new(username: 'abc', password: 'xyz')
```

To get an overview of traffic conditions:

```ruby
  client.traffic_conditions
```

Which returns broad measures of congestion ('Free flow', 'Moderate',
'Heavy').


The segment APIs give you more granular data, such as the speed of
traffic moving on that segment and average occupancy of each vehicle.

The key Auckland segments have an id of 5

```ruby
  client.segments(5)
```

If you would like to map these segments you can receive a GeoJSON
representation with:

```ruby
  client.segment_geojson(5)
```

Example output: http://bl.ocks.org/d/be62de78f8c14230f2d95bf987363a44


#### Work in progress

```ruby
  client.treis
```

Currently the XML representation of the TREIS endpoint. WIP.

![Auckland Traffic Segments](http://i.imgur.com/uXcjjbe.png)


## Development

If you clone this repository you can experiment with adding a `.env`
file with your NZTA credentials and run `bin/console`

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/nzherald/nzta/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
