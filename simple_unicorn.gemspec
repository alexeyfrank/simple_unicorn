# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_unicorn/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_unicorn"
  gem.version       = SimpleUnicorn::VERSION
  gem.authors       = ["Alexey Frank"]
  gem.email         = ["alexeyfrank@gmail.com"]
  gem.description   = %q{TO2DO: Write a gem description}
  gem.summary       = %q{TO2DO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'http_parser.rb'
end
