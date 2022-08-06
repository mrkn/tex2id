# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tex2id/version'

Gem::Specification.new do |spec|
  spec.name          = "tex2id"
  spec.version       = Tex2id::VERSION
  spec.authors       = ["Kenta Murata"]
  spec.email         = ["mrkn@cookpad.com"]

  spec.summary       = %q{TeX 2 InDesign}
  spec.description   = %q{Convert TeX notation to InDesign markup.}
  spec.homepage      = "https://github.com/mrkn/tex2id"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fuubar"

  spec.required_ruby_version = '>= 3.0.0'
end
