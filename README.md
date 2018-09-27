This gem is an implementation of the JSON-LD Signatures specification
in Ruby that supports the following encryption options:

* RSA
* Ed25519

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

Tests
-----

Consider the following JSON document:

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
