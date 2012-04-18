# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require 'john-hancock/version'

Gem::Specification.new do |s|
  s.name        = %q{john-hancock}
  s.version     = JohnHancock::VERSION.dup
  s.authors     = ["Brandon Turner"]
  s.email       = %q{bt@brandonturner.net}
  s.homepage    = %q{http://github.com/thinkwell/john-hancock}
  s.summary     = %q{Library for signing and verifying url signatures}
  s.description = %q{Extendable library for signing and verifying url/request signatures}
  s.licenses    = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<i18n>, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>, [">= 0"])

  s.add_development_dependency(%q<bundler>, [">= 1.0.21"])
  s.add_development_dependency(%q<rake>, [">= 0"])
end

