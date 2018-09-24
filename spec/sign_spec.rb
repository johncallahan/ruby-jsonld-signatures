require 'ed25519'
require 'spec_helper'

describe JSON::LD::SIGNATURE::Sign do
  before :each do
    @pub = Ed25519::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
    @priv = Ed25519::SigningKey.new ["f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
  end
  
  context "test files" do
    test_files = {
        "basic_jsonld" => "data/rop_media_type.jsonld"
    }
    
    it "is possible to sign a basic document" do
      file = File.read(test_files['basic_jsonld'])
      signed = JSON::LD::SIGNATURE::Sign.sign file, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
      puts signed
    end
  end
  
#  describe "sign" do
#    it "is possible to sign a basic document" do
#      file = File.read(test_files['basic_jsonld'])
#      signed = 
#      puts @pub
#      puts @priv    
#    end
#  end
end