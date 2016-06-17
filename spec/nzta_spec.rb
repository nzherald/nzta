require 'spec_helper'

describe NZTA do
  it 'has a version number' do
    expect(NZTA::VERSION).not_to be nil
  end

  it 'uses BasicHTTPClient by default' do
    client = NZTA::Client.new
    expect(client.http_client.class).to be NZTA::BasicHTTPClient
  end
end
