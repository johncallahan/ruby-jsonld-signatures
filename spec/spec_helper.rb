$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler/setup'
require 'json/ld/signature'

require 'openssl'
require 'yaml'

require 'webmock/rspec'
#WebMock.disable_net_connect!(allow_localhost: true)
WebMock.disable!

RSpec.configure do |config|
  security = File.read("data/w3_security-v1.jsonld")
  credentials = File.read("data/w3_credentials-v1.jsonld")
  config.before(:each) do
    stub_request(:get, "https://w3id.org/credentials/v1").
      to_return(:status => 200, :body => credentials, :headers => {})
    stub_request(:get, "https://w3id.org/security/v1").
      to_return(:status => 200, :body => security, :headers => {})
  end
end
