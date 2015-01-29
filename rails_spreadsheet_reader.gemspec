# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_spreadsheet_reader/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_spreadsheet_reader'
  spec.version       = RailsSpreadsheetReader::VERSION
  spec.authors       = ['muzk']
  spec.email         = ['ngomez@hasu.cl']
  spec.description   = 'Provides an easy way to add model-based validations to excel files.'
  spec.summary       = 'Provides an easy way to add model-based validations to excel files.'
  spec.homepage      = 'https://github.com/HasuSoftware/rails_spreadsheet_reader'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'factory_girl', '~> 4.4'

  spec.add_dependency 'roo', '~> 1.13'
  spec.add_dependency 'rails', '~> 4.2.0'
end
