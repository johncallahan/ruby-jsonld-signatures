module JSON
  module LD
    module SIGNATURE
      require 'base64'
      require 'json/ld'
      require 'rdf/normalize'
      require 'json/ld/signature/ed25519Signer'
      require 'json/ld/signature/ed25519Verifier'
      
#      autoload :Signer, 'json/ld/signature/ed25519Signer'
#      autoload :Verifier, 'json/ld/signature/ed255Verifier'

      class Signer

        attr_writer :suite
	attr_writer :pub
	attr_writer :priv
      
        def sign
	  suite.sign()
	end

	def suite
	  @suite ||= Ed25519Signer.new
	end

	def pub
	  @pub
	end

	def priv
	  @priv
	end

      end

      class Verifier

        attr_writer :suite
        attr_writer :pub
        attr_writer :priv
      
        def verify
	  suite.verify()
	end

	def suite
	  @suite ||= Ed25519Verifier.new
	end

	def pub
	  @pub
	end

	def priv
	  @priv
	end

      end
      
      def generateNormalizedGraph(jsonLDDoc, opts)
        jsonLDDoc.delete 'signature'

        graph = RDF::Graph.new << JSON::LD::API.toRdf(jsonLDDoc)
        # TODO: Parameterize the normalization
        normalized = graph.dump(:normalize)

#        digestdoc = ''
#        digestdoc << opts['nonce'] unless opts['nonce'].nil?
#        digestdoc << opts['created']
#        digestdoc << normalized
#        digestdoc << '@' + opts['domain'] unless opts['domain'].nil?
#        digestdoc
	 normalized
      end

      module_function :generateNormalizedGraph
      
      SECURITY_CONTEXT_URL = 'https://w3id.org/security/v1'
      
      class JsonLdSignatureError < JsonLdError
        class InvalidJsonLdDocument < JsonLdSignatureError; @code = "invalid JSON-LD document"; end
        class MissingCreator < JsonLdSignatureError; @code = "missing signature creator"; end
        class MissingKey < JsonLdSignatureError; @code = "missing private PEM formatted string"; end
        class InvalidKeyType < JsonLdSignatureError; @code = "invalid PEM key"; end
        class WrongKeyType < JsonLdSignatureError; @code = "signing requires a private key"; end
        class UnreachableKey < JsonLdSignatureError; @code = "unable to retrieve public key"; end
      end
    end
  end
end
