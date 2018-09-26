require 'json'
require 'ed25519'
require 'spec_helper'

describe JSON::LD::SIGNATURE::Verify do
    before :each do
      @pub = Ed25519::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
      @priv = Ed25519::SigningKey.new ["7f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
    end

    context "test files" do
      test_files = {
          "basic_jsonld" => "data/rop_media_type.jsonld",
          "bad_sig_jsonld" => "data/rop_media_type_bad_sig.jsonld",
          "good_sig_jsonld" => "data/rop_media_type_good_sig.jsonld"
      }

      it "is possible to verify a signed basic document" do
        file = File.read(test_files['basic_jsonld'])
        signed = JSON::LD::SIGNATURE::Sign.sign file, { 'privateKey' => @priv, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
        verified = JSON::LD::SIGNATURE::Verify.verify signed, { 'publicKey' => @pub, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
#        puts "VERIFIED: #{verified}"
      end

      it "is possible to NOT verify a signed basic document" do
        file = File.read(test_files['bad_sig_jsonld'])
        expect { JSON::LD::SIGNATURE::Verify.verify file, { 'publicKey' => @pub, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'} }.to raise_error Ed25519::VerifyError
      end

      it "is possible to verify a signed basic document from a file" do
        file = File.read(test_files['good_sig_jsonld'])
        verified = JSON::LD::SIGNATURE::Verify.verify file, { 'publicKey' => @pub, 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
#        puts "VERIFIED: #{verified}"
      end

    end
end
