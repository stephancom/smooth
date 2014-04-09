$:.push File.expand_path("../lib", __FILE__)
require 'smooth/version'

Gem::Specification.new do |s|
  s.name          = "smooth-io"
  s.version       = Smooth::Version
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Jonathan Soeder"]
  s.email         = ["jonathan.soeder@gmail.com"] 
  s.homepage      = "http://smooth.io"
  s.summary       = "Smooth persistence"
  s.description   = "Cross platform, syncable persistence"

  s.add_dependency 'activesupport', '~> 4.1.0'
  s.add_dependency 'activerecord', '~> 4.1.0'
  s.add_dependency 'active_model_serializers', '~> 0.8.1'
  s.add_dependency 'virtus', '0.5.5'
  s.add_dependency 'redis'
  s.add_dependency 'redis-objects'
  s.add_dependency 'redis-namespace'
  s.add_dependency "typhoeus"
  s.add_dependency "commander"

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
