$:.push File.expand_path("../lib", __FILE__)
require 'smooth/version'

Gem::Specification.new do |s|
  s.name          = "smooth"
  s.version       = Smooth::Version
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Jonathan Soeder"]
  s.email         = ["jonathan.soeder@gmail.com"] 
  s.homepage      = "http://smooth.io"
  s.summary       = "Smooth persistence"
  s.description   = "Cross platform, syncable persistence"

  s.add_dependency 'activerecord', '>= 3.2.12'
  s.add_dependency 'activesupport', '>= 3.2.12'
  s.add_dependency 'redis'
  s.add_dependency 'redis-namespace'
  s.add_dependency 'typhoeus'
  s.add_dependency 'virtus', '0.5.5'
  s.add_dependency 'faye'
  s.add_dependency 'sinatra'
  s.add_dependency 'squeel'

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'machinist', '~> 1.0.6'
  s.add_development_dependency 'faker', '~> 0.9.5'
  s.add_development_dependency 'sqlite3', '~> 1.3.3'
  s.add_development_dependency 'rack-test'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
