$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth_rails"
  s.version     = AuthRails::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = "Summary of AuthRails."
  s.description = "Description of AuthRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.2"
  s.add_dependency "jbuilder", "~> 2.8.0"
  s.add_dependency "bcrypt", "~> 3.1.7"
  s.add_dependency "rack-cors", "~> 1.0.2"
  s.add_dependency "jwt", "~> 2.1.0"
  s.add_dependency "pg", "~> 1.1.4"

  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec-rails", '~> 3.6'
  s.add_development_dependency "factory_bot", '~> 4.8.2'
  s.add_development_dependency "faker", '~> 1.8.6'
  s.add_development_dependency "webmock", '~> 3.1.1'
  s.add_development_dependency "listen", '>= 3.0.5', '< 3.2'
  s.add_development_dependency "spring"
  s.add_development_dependency "spring-watcher-listen", '~> 2.0.0'
end
