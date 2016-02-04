# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'milight/version'

Gem::Specification.new do |spec|
  spec.name          = "milight"
  spec.version       = Milight::VERSION
  spec.authors       = ["beco-ippei"]
  spec.email         = ["beco.ippei@gmail.com"]

  spec.summary       = %q{A ruby controller for Mi-Light LED bulb.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/beco-ippei/ruby-milight"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "pkg"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
