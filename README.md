[![Build Status](https://travis-ci.org/johncallahan/ruby-jsonld-signatures.svg?branch=master)](https://travis-ci.org/johncallahan/ruby-jsonld-signatures) [![Gem Version](https://badge.fury.io/rb/ruby-jsonld-signatures.svg)](https://badge.fury.io/rb/ruby-jsonld-signatures) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This [gem](https://rubygems.org/gems/ruby-jsonld-signatures) is an implementation of the JSON-LD Signatures specification
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
% git clone https://github.com/johncallahan/ruby-jsonld-signatures.git
% bundle install
% rspec
```

You can experiment with the gem on a command line:

```shell
% irb -I lib -r 'json/ld/signature' -r 'ed25519'
> signer = JSON::LD::SIGNATURE::Ed25519Signer.new
> signer.pub = Ed25519::VerifyKey.new ["ff1a646cc8b69fcb522aa1ed162bc2816878252a634384ce46f7507bfc92f68f"].pack('H*')
> signer.priv = Ed25519::SigningKey.new ["7f702a609f842057be24b5297e451662876f03b047d660362cd123f71d2a3b63"].pack('H*')
> file = File.read('data/testdoc.jsonld')
> signed = signer.sign file, { 'creator' => 'did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1'}
> CTL-D
```

You can bump the VERSION, update the ruby-jsonld-signatures.gemspec
file, commit changes, and then

```shell
% gem build ruby-jsonld-signatures.gemspec 
% gem push ruby-jsonld-signatures-0.0.xx.gem 
```

for the gem file produced as a result of the build (this generated
file is NOT add or committed to git).

Description
-----------

Consider the following JSON-LD document:

```json
{
  "@context": [
    "http://schema.org/",
    "https://w3id.org/security/v2"
  ],
  "name": "Manu Sporny",
  "homepage": "https://manu.sporny.org/",
  "image": "https://manu.sporny.org/images/manu.png"
}
```

The goal of [Linked Data Signatures](https://w3c-dvcg.github.io/ld-signatures/) is to
cryptographically "sign" a JSON-LD document such that the the order of
key/pairs within the JSON-LD document does not matter.  In other words,
the signature value of the JSON content above would be:

```
qMt05czF5xKG+HwLrlqp+ja+8qtXDMINfY/eWKFIXYy0eqIj8S32OY0cYQHZqfZbTpA4v9J6vq+FaG5oSLvACg==
```

The following document is equivalent to the JSON-LD document above even
though more whitespace is added and the key/value pairs (even in
embedded blocks) are in different order but their values are equal:

```json
{
  "image": "https://manu.sporny.org/images/manu.png",
  "name": "Manu Sporny",
  "@context": [
    "http://schema.org/",
    "https://w3id.org/security/v2"
  ],
  "homepage": "https://manu.sporny.org/"
}
```

After generating the signature value for the JSON-LD document, the
signature value is appended to the document with additional metadata:

```json
{
  "@context":[
    "http://schema.org/","https://w3id.org/security/v2"
  ],
  "name":"Manu Sporny",
  "homepage":"https://manu.sporny.org/",
  "image":"https://manu.sporny.org/images/manu.png",
  "signature":{
    "type":"Ed25519Signature2018",
    "creator":"did:v1:test:nym:JApJf12r82Pe6PBJ3gJAAwo8F7uDnae6B4ab9EFQ7XXk#authn-key-1",
    "created":"2018-03-15T00:00:00Z",
    "signatureValue":"qMt05czF5xKG+HwLrlqp+ja+8qtXDMINfY/eWKFIXYy0eqIj8S32OY0cYQHZqfZbTpA4v9J6vq+FaG5oSLvACg=="
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

NOTE: additional keys can be caught in generic schema.org and will
still be part of the normalization process.  Thus, the following
JSON-LD document is equalivalent to the blocks shown above:

```json
{
  "@context": [
    "http://schema.org/",
    "https://w3id.org/security/v2"
  ],
  "name": "Manu Sporny",
  "foo": "bar",
  "homepage": "https://manu.sporny.org/",
  "image": "https://manu.sporny.org/images/manu.png"
}
```

The key "foo" will be put in the scheme.org context and included in
the normalized content.

Tests
-----

* Sign a basic string
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

