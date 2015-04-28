$:.push File.expand_path("../lib", __FILE__)
require "eigindir/version"

Gem::Specification.new do |gem|

  gem.name     = "eigindir"
  gem.version  = Eigindir::VERSION.dup
  gem.author   = "Andrew Kozin"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/nepalez/eigindir"
  gem.summary  = "Declaration and coercion of PORO attributes"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = "~> 2.1"
  gem.add_development_dependency "hexx-rspec", "~> 0.4"

end # Gem::Specification
