require 'ed25519'
#require 'rbnacl'
require 'spec_helper'

describe JSON::LD::SIGNATURE::Sign do
  before :each do
    @pub = Ed25519::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
    @priv = Ed25519::SigningKey.new ["7f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
#     @priv = RbNaCl::SigningKey.new ["f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
#    @pub = RbNaCl::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
  end
  
  context "test files" do
    test_files = {
        "basic_jsonld" => "data/rop_media_type.jsonld",
	  "basic_jsonld_non" => "data/rop_media_type_with_non.jsonld",
	  "basic_jsonld_second" => "data/rop_media_type_second.jsonld",
	  "basic_jsonld_reordered" => "data/rop_media_type_reordered.jsonld"
    }
    
    it "is possible to sign a basic document" do
      file = File.read(test_files['basic_jsonld'])
      signed = JSON::LD::SIGNATURE::Sign.sign file, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
#      puts signed
    end

      it "does not matter if a document contains a non-vocabulary element" do
        file1 = File.read(test_files['basic_jsonld'])
        file2 = File.read(test_files['basic_jsonld_non'])
        signed1 = JSON::LD::SIGNATURE::Sign.sign file1, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
        signed2 = JSON::LD::SIGNATURE::Sign.sign file2, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
	signed1_hash = JSON.parse(signed1)
	signed2_hash = JSON.parse(signed2)
#	puts signed1_hash['signature']['signatureValue']
#	puts signed1
#	puts signed2
	signed1['signature']['signatureValue'] == signed2['signature']['signatureValue']
      end

      it "matters if a document contains a vocabulary element" do
        file1 = File.read(test_files['basic_jsonld'])
        file2 = File.read(test_files['basic_jsonld_second'])
        signed1 = JSON::LD::SIGNATURE::Sign.sign file1, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
        signed2 = JSON::LD::SIGNATURE::Sign.sign file2, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
	signed1_hash = JSON.parse(signed1)
	signed2_hash = JSON.parse(signed2)
#	puts signed1_hash['signature']['signatureValue']
#	puts signed1
#	puts signed2
	signed1['signature']['signatureValue'] != signed2['signature']['signatureValue']
      end

      it "does not matter if elements are in different order" do
        file1 = File.read(test_files['basic_jsonld'])
        file2 = File.read(test_files['basic_jsonld_reordered'])
        signed1 = JSON::LD::SIGNATURE::Sign.sign file1, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
        signed2 = JSON::LD::SIGNATURE::Sign.sign file2, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
	signed1_hash = JSON.parse(signed1)
	signed2_hash = JSON.parse(signed2)
#	puts signed1_hash['signature']['signatureValue']
#	puts signed1
#	puts signed2
	signed1['signature']['signatureValue'] == signed2['signature']['signatureValue']
      end
  
  end

end
