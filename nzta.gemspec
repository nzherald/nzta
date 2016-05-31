# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nzta/version'

Gem::Specification.new do |spec|
  spec.name          = 'nzta'
  spec.version       = NZTA::VERSION
  spec.authors       = ['Caleb']
  spec.email         = ['caleb.tutty@nzherald.co.nz']

  spec.summary       = %q{NZTA is a gem to query the NZTA InfoConnect REST API}
  spec.homepage      = "https://github.com/nzherald/nzta"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 0.8.12'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'curb'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
