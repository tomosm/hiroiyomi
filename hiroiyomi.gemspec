# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiroiyomi/version'

Gem::Specification.new do |spec|
  spec.name          = 'hiroiyomi'
  spec.version       = Hiroiyomi::VERSION
  spec.authors       = ['Tomonori Murakami']
  spec.email         = ['crosslife777@gmail.com']

  spec.summary       = %q{hiroiyomi helps you to scan a html resource and filter elements.}
  spec.description   = %q{hiroiyomi helps you to scan a html resource and filter elements.}
  spec.homepage      = 'https://github.com/tomosm/hiroiyomi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
end
