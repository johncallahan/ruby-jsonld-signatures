require 'ed25519'
#require 'rbnacl'
require 'spec_helper'

describe JSON::LD::SIGNATURE::Signer do
  before :each do
    @pub = Ed25519::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
    @priv = Ed25519::SigningKey.new ["7f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
#     @priv = RbNaCl::SigningKey.new ["f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
#    @pub = RbNaCl::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
  end
  
  context "test files" do
    test_files = {
        "basic_canon" => "data/testdoc.canon"
    }
    
    it "is possible to sign a basic canon document" do
      file = File.read(test_files['basic_canon'])
      signatureValue = @priv.sign file
#      puts Base64.strict_encode64(signatureValue)
    end
  end
  
end