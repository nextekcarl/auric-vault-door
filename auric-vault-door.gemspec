# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auric/vault/door/version'

Gem::Specification.new do |spec|
  spec.name          = "auric-vault-door"
  spec.version       = Auric::Vault::Door::VERSION
  spec.authors       = ["Carl Anderson"]
  spec.email         = ["carl@planetargon.com"]
  spec.summary       = %q{Provides access to the Auric Vault API.}
  spec.description   = %q{Provides access to API at https://www.auricsystems.com/products/paymentvault-tokenization/ for storing data using a token.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
