# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fife/version'

Gem::Specification.new do |spec|
  spec.name          = 'fife'
  spec.version       = Fife::VERSION
  spec.authors       = ['aetherus']
  spec.email         = ['aetherus.zhou@gmail.com']

  spec.summary       = 'A multiple IO pipelining tool'
  spec.description   = %q{
    A multiple IO pipelining tool.
    You can use it to spawn as many or as few IO-like instances from 0 or more IO-like instances.
  }
  spec.homepage      = 'https://github.com/aetherus/fife'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_runtime_dependency 'net-sftp'
  spec.add_runtime_dependency 'activesupport'
end
