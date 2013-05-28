# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gfspark/version'

Gem::Specification.new do |gem|
  gem.name          = "gfspark"
  gem.version       = Gfspark::VERSION
  gem.authors       = ["Tomohito Ozaki"]
  gem.email         = ["ozaki@yuroyoro.com"]
  gem.description   = %q{GrowthForecast on Terminal}
  gem.summary       = %q{GrowthForecast Graph viewer on Terminal}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  s.add_dependency 'json'
  s.add_dependency 'term-ansicolor'
end
