require 'spec_helper'

describe JSON::LD::SIGNATURE::RsaVerifier do
    before :each do
      @signer = JSON::LD::SIGNATURE::RsaSigner.new
      @verifier = JSON::LD::SIGNATURE::RsaVerifier.new
      @signer.pub = OpenSSL::PKey::RSA.new File.read 'data/pub_key.pem'
      @signer.priv = OpenSSL::PKey::RSA.new File.read 'data/priv_key.pem'
      @verifier.pub = OpenSSL::PKey::RSA.new File.read 'data/pub_key.pem'
      @verifier.priv = OpenSSL::PKey::RSA.new File.read 'data/priv_key.pem'
    end

    context "test files" do
      test_files = {
          "basic_jsonld" => "data/testdoc.jsonld"
      }

      it "is possible to verify a signed basic document" do
        file = File.read(test_files['basic_jsonld'])
        signed = @signer.sign file, { 'creator' => 'http://example.com/foo/key/1'}
        verified = @verifier.verify signed, { 'creator' => 'http://example.com/foo/key/1'}
	expect(verified).to be true
      end
    end

  end