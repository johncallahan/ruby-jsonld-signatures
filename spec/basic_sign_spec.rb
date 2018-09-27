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
  
  context "test encryption" do
    it "is possible to encrypt a basic string" do
      signatureValue = @priv.sign "Hello world"
#      puts Base64.strict_encode64(signatureValue)
    end
  end
  
end