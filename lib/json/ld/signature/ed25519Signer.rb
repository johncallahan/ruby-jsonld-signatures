module JSON::LD::SIGNATURE::ED25519

  class Signer

    attr_writer :pub
    attr_writer :priv

    def pub
      @pub
    end

    def priv
      @priv
    end

    def sign(input, options = {} )
      
      # We require a creator to identify the signing key
      
      if options['creator'].nil?
        raise JsonLdSignatureError::MissingCreator, "the creator of the signature must be identified"
      end
      
      creator = options['creator']
      
      # TODO: Validate the resolvability of the URL?

      # We require a privateKeyPem in the options hash
#      if options['privateKey'].nil?
#        raise JsonLdSignatureError::MissingKey, "options parameter must include privateKey"
#      end

      # The privateKeyPem can be either a String or a parsed RSA key
#      privateKey = options['privateKey']
      privateKey = priv

#      unless privateKey.private?
#        raise JsonLdSignatureError::WrongKeyType, "submitted key is a public key"
#      end

      # Check the input, it should either be a String or a parsed JSON object

      jsonld = case input
      when String then 
      begin
          JSON.parse(input)        
        rescue JSON::ParserError => e
            raise JsonLdSignatureError::InvalidJsonLdDocument, e.message
      end 
      when Hash then input
      else
        raise JsonLdSignatureError::InvalidJsonLdDocument
      end
      
      jsonld.delete 'signature'
#      created = Time.now.iso8601
      created = "2018-03-15T00:00:00Z"
#     nonce = options['nonce']
#      nonce = "3699b48f-a194-4415-8da3-b76269f63746"
       nonce = nil
#      domain = options['domain']
      domain = nil
            
      normOpts = {
        'nonce' => nonce,
        'domain' => options['domain'],
        'created' => created,
        'creator' => creator
      }
      
      normalizedGraph = JSON::LD::SIGNATURE::generateNormalizedGraph jsonld, normOpts
#      puts normalizedGraph
      signature = privateKey.sign normalizedGraph

      enc = Base64.strict_encode64(signature)
      
       # "@context" : "https://w3id.org/security/v1",

      sigobj = JSON.parse %({
        "type" : "Ed25519Signature2018",
        "creator" : "#{creator}",
        "created" : "#{created}",
        "signatureValue" : "#{enc}"
      })
      
      sigobj['domain'] = domain unless options['domain'].nil?
      sigobj['nonce'] = nonce unless nonce.nil?
      
      jsonld['signature'] = sigobj
      jsonld.to_json
    end
  end
end

