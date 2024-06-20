# frozen_string_literal: true

require_relative 'lib/active_storage_bunny/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_storage_bunny'
  spec.version       = ::ActiveStorageBunny::VERSION
  spec.authors       = ['Ramit Koul']
  spec.email         = ['ramitkaul@gmail.com']

  spec.summary       = 'An Active Storage service for BunnyCDN storage services.'
  spec.description   = 'ActiveStorageBunny is a gem that integrates BunnyCDN storage services with Active Storage.'
  spec.homepage      = 'https://github.com/rkwap/active_storage_bunny'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'
  spec.add_dependency 'bunny_storage_client', '~> 1.0'
  spec.add_dependency 'rails', '>= 6.0', '< 8.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"
end