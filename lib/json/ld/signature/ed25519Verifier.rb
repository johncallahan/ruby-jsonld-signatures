module JSON
  module LD
    module SIGNATURE
      module ED25519

  class Verifier

    attr_writer :pub
    attr_writer :priv

    def pub
      @pub
    end

    def priv
      @priv
    end
    
    def verify(input, options = {})
      
      # We require a publicKeyPem in the options hash
#      if options['publicKey'].nil?
#        raise JsonLdSignatureError::MissingKey, "options parameter must include publicKey"
#      end

      # The publicKeyPem can be either a String or a parsed RSA key
#      publicKey = options['publicKey']
      publicKey = pub
      
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
      
      signature = jsonld['signature']
      
      created = signature['created']
      creator = signature['creator']
      signatureValue = signature['signatureValue']
      domain = signature['domain']
      nonce = signature['nonce']
      
      uri = URI(creator)
      
      normOpts = {
        'nonce' => nonce,
        'domain' => domain,
        'created' => created,
        'creator' => creator
      }
      
      normalizedGraph = JSON::LD::SIGNATURE::generateNormalizedGraph jsonld, normOpts

      publicKey.verify Base64.decode64(signatureValue), normalizedGraph
    end
  end
end
end
end
end
