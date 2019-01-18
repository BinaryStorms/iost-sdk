lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iost_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'iost_sdk'
  spec.version       = IOSTSdk::VERSION
  spec.authors       = ['Han Wang']
  spec.email         = ['han@binarystorms.com']

  spec.summary       = 'Ruby SDK for the IOST Blockchain'
  spec.description   = 'Ruby SDK for the IOST Blockchain. See https://iost.io/ for details on IOST.'
  spec.homepage      = 'https://github.com/BinaryStorms/iost-sdk'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").select { |f| f.match(%r{^lib/}) }
  end

  spec.require_paths = ['lib']
  spec.metadata['yard.run'] = 'yard'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8.22'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'yard', '~> 0.9.16'
  # dependencies
  spec.add_dependency 'base58', '~> 0.2.3'
  spec.add_dependency 'ed25519', '~> 1.2.4'
  spec.add_dependency 'httparty', '~> 0.16'
end
