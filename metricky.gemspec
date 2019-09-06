$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "metricky/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "metricky"
  spec.version     = Metricky::VERSION
  spec.authors     = ["Josh Brody"]
  spec.email       = ["josh@josh.mn"]
  spec.homepage    = "https://github.com/joshmn/metricky"
  spec.summary     = "A simple stats."
  spec.description = "Metricky"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.add_dependency "rails", "> 5.1"
  spec.add_dependency "groupdate", "> 4.0"
  spec.add_dependency "chartkick", "> 3.0"
end
