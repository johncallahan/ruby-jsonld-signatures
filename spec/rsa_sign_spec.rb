require 'spec_helper'

describe JSON::LD::SIGNATURE::RsaSigner do
  before :each do
    @signer = JSON::LD::SIGNATURE::RsaSigner.new
    @signer.pub = OpenSSL::PKey::RSA.new File.read 'data/pub_key.pem'
    @signer.priv = OpenSSL::PKey::RSA.new File.read 'data/priv_key.pem'
  end
  
  context "test files" do
    test_files = {
        "basic_jsonld" => "data/testdoc.jsonld"
    }
    
    it "is possible to sign a basic document" do
      file = File.read(test_files['basic_jsonld'])
      signed = @signer.sign file, { 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
#      puts signed
    end
  end
  
end