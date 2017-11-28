# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sportradar/api/version'

Gem::Specification.new do |spec|
  spec.name          = "sportradar-api"
  spec.version       = Sportradar::Api::VERSION
  spec.authors       = ["Ben Eggett"]
  spec.email         = ["beneggett@gmail.com"]

  spec.summary       = %q{ Sportradar API client }
  spec.description   = %q{ Ruby wrapper for interacting with the SportRadar API. SportRadar has over 23 published APIs. This library aims to support them incrementally. Contributions welcome! }
  spec.homepage      = "https://github.com/beneggett/sportradar-api"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "minitest-focus"
  spec.add_development_dependency "dotenv"

  spec.add_dependency "httparty", ">= 0.14.0"
  # spec.add_dependency "activesupport"

end
