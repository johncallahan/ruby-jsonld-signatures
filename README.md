[![Build Status](https://travis-ci.org/johncallahan/ruby-jsonld-signatures.svg?branch=master)](https://travis-ci.org/johncallahan/ruby-jsonld-signatures)

This gem is an implementation of the JSON-LD Signatures specification
in Ruby that supports the following encryption options:

* RSA
* Ed25519

Demo
----

See [an example](https://ldsigdemo.herokuapp.com/) of the gem in action.  The source code for the demo is [here](https://github.com/johncallahan/ldsigdemo).

Getting Started
---------------

Add the gem to your Gemfile:

```ruby
gem 'ruby-jsonld-signatures'
```

then run `bundle install`

Development
-----------

Clone this repo, bundle and run the rspec tests:

```shell
git clone https://github.com/johncallahan/ruby-jsonld-signatures.git
bundle install
rspec
```

Description
-----------

Consider the following JSON-LD document:

```json
{
  "@context": [ "https://w3id.org/credentials/v1","https://w3id.org/security/v1"],
  "type" : [ "Credential" ],
  "claim" : {
    "id" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
    "publicKey" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1"
  },
  "issuer" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
  "issued" : "2018-03-15T00:00:00Z"
}
```

The goal of [Linked Data Signatures](https://w3c-dvcg.github.io/ld-signatures/) is to
cryptographically "sign" a JSON-LD document such that the the order of
key/pairs within the JSON-LD document does not matter.  In other words,
the signature value of the JSON content above would be:

```
t/T2Wv335B2guVYW88I9uWKEdrE3HFddrXt14AVo9aD9yr5BAbGJT5eQbVGdG+O0Hn6RU9IYgi1o15/F3x37Ag==
```

The following document is equivalent to the JSON-LD document above even
though more whitespace is added and the key/value pairs (even in
embedded blocks) are in different order but their values are equal:

```json
{
  "issued" : "2018-03-15T00:00:00Z",

     "issuer" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
     "claim" : {
       "publicKey" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1",
       "id" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk"
     },

  "type" : [ "Credential" ],
  "@context": [ "https://w3id.org/credentials/v1","https://w3id.org/security/v1"]
}

```

After generating the signature value for the JSON-LD document, the
signature value is appended to the document with additional metadata:

```json
{
  "@context":["https://w3id.org/credentials/v1","https://w3id.org/security/v1"],
  "type":["Credential"],
  "claim":{
    "id":"did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
    "publicKey":"did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1"
  },
  "issuer":"did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
  "issued":"2018-03-15T00:00:00Z",
  "signature":{
    "type":"Ed25519Signature2018",
    "creator":"did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1",
    "created":"2018-03-15T00:00:00Z",
    "signatureValue":"t/T2Wv335B2guVYW88I9uWKEdrE3HFddrXt14AVo9aD9yr5BAbGJT5eQbVGdG+O0Hn6RU9IYgi1o15/F3x37Ag=="
  }
}
```

This signed content can be presented to other parties such that any
key/value pair change to the JSON content (not the order or
whitespace) can be detected.  It is useful in [DID Auth](https://github.com/WebOfTrustInfo/rebooting-the-web-of-trust-spring2018/blob/master/final-documents/did-auth.md) where a
user (via their browser or mobile device) holds a private key and
needs to provide [verifiable credentials](https://github.com/WebOfTrustInfo/rwot7/blob/master/topics-and-advance-readings/verifiable-credentials-primer.md) to a replying party or
service provider.  In the case of DID Auth, the relying party can
verify the signature by resolving the DID (via a [universal
resolver](https://github.com/decentralized-identity/universal-resolver)) to obtain the public key from a blockchain ([Veres
One](https://github.com/veres-one/veres-one) in this case).

The process of signing a JSON-LD document includes:

* resolving the context vocabularies (i.e., fetching them via their URLs in the @context]
* normalizing (or sometimes called 'canonicalizing') the document
* determining the signature value with a private key (using RSA or Ed25519)
* embedding the signature JSON with the metadata and signature value (not part of the JSON-LD document)

Verifying a signed JSON-LD document includes:

* extracting the signature block from the JSON-LD document (remove it as well)
* normalizing (or sometimes called 'canonicalizing') the remaining JSON-LD document
* verifying the signature value with the public key (using RSA or Ed25519)

The ruby-jsonld-signatures gem relies on other gems to perform signing
and verifying including:

* [json-ld](https://github.com/ruby-rdf/json-ld)
* [rdf-normalize](https://github.com/ruby-rdf/rdf-normalize)
* [ed25519](https://github.com/crypto-rb/ed25519)

NOTE: additional keys that are NOT in the context vocabularies will
NOT be part of the normalization process.  Thus, the following JSON-LD
document is equalivalent to the blocks shown above:

```json
{
  "@context": [ "https://w3id.org/credentials/v1","https://w3id.org/security/v1"],
  "type" : [ "Credential" ],
  "claim" : {
    "id" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
    "publicKey" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1"
  },
  "foo" : "bar",
  "issuer" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
  "issued" : "2018-03-15T00:00:00Z"
}
```

The key "foo" is not found in either the credentials or security
vocabularies (in the @context) and therefore *not* included in the
normalized content.  But the following document is not equivalent (the
key "nonce" *is* part of both the credentials and security
vocabularies - but it just has to be in one of them):

```json
{
  "@context": [ "https://w3id.org/credentials/v1","https://w3id.org/security/v1"],
  "type" : [ "Credential" ],
  "claim" : {
    "id" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
    "publicKey" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1"
  },
  "nonce" : "thisisjustarandomstring",
  "issuer" : "did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk",
  "issued" : "2018-03-15T00:00:00Z"
}
```

By the way, here is the normalized (or "canonicalized") content for
all blocks above except the one with the "nonce" key-value pair added:

```json
<did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk> <https://w3id.org/security#publicKey> <did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1> .
_:c14n0 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://w3id.org/credentials#Credential> .
_:c14n0 <https://w3id.org/credentials#claim> <did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk> .
_:c14n0 <https://w3id.org/credentials#issued> "2018-03-15T00:00:00Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
_:c14n0 <https://w3id.org/credentials#issuer> <did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk> .
```

Tests
-----

* Sign a basic string
* Sign a basic normalized (i.e., "canonicalized") document
* Sign a basic JSON-LD document
* Signatures of a second document that contains a non-vocabulary element are equivalent
* Signatures of a second document that contains a vocabulary element are NOT equivalent
* Signatures of a second document in different order are equivalent
* Verify signature of a signed JSON-LD document
* Detect when signature of a signed JSON-LD document is invalid

Todo
----

* The gem currently uses the [ed25519](https://github.com/crypto-rb/ed25519) gem, but I have tested the
  [rbnacl](https://github.com/crypto-rb/rbnacl) gem and it works.  I just need to provide an option hook.

