#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version               = File.read('VERSION').chomp
  gem.date                  = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name                  = "ruby-jsonld-signatures"
  gem.homepage              = "http://github.com/bsletten/rdf-jsonld-signature"
  gem.license               = 'MIT' if gem.respond_to?(:license=)
  gem.summary               = "JSON-LD Signature implementation for Ruby."
  gem.description           = %q{RDF::JSON::LD:Signature is an implementation of the JSON-LD Signature specification for the RDF.rb library suite.}
  gem.rubyforge_project     = 'rdf-normalize'

  gem.authors               = ['Brian Sletten', "John Callahan"]
  gem.email                 = 'public-rdf-ruby@w3.org'

  gem.platform              = Gem::Platform::RUBY
  gem.files                 = %w(AUTHORS README.md LICENSE VERSION) + Dir.glob('lib/**/*.rb')
  #gem.bindir               = %q(bin)
  #gem.default_executable   = gem.executables.first
  gem.require_paths         = %w(lib)
  gem.extensions            = %w()
  gem.test_files            = %w()
  #gem.has_rdoc              = false

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency             'rdf',             '~> 3.0.4'
  gem.add_dependency             'rdf-normalize'
  gem.add_dependency             'rdf-turtle'
  gem.add_development_dependency 'rdf-spec'
  gem.add_development_dependency 'open-uri-cached', '~> 0.0', '>= 0.0.5'
  gem.add_development_dependency 'rspec',           '~> 3.2'
  gem.add_development_dependency 'webmock',         '~> 2.3.2'
  gem.add_development_dependency 'json-ld',         '~> 3.0.2'
  gem.add_development_dependency 'yard' ,           '~> 0.8'
  gem.post_install_message  = nil
end
