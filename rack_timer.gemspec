# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack_timer/version"

Gem::Specification.new do |s|
  s.name        = "rack_timer"
  s.version     = RackTimer::VERSION
  s.authors     = ["lukeludwig", 'bachue']
  s.email       = ["luke@lukeludwig.com", "bachue.shu@gmail.com"]
  s.homepage    = "http://www.github.com/gitcafe-dev/rack_timer"
  s.summary     = %q{Provides timing output around each of your Rails rack-based middleware classes.}
  s.description = %q{Provides timing output around each of your Rails rack-based middleware classes.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activesupport', '~> 3.2'
end
