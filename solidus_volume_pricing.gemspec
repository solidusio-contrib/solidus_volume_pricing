lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'solidus_volume_pricing/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_volume_pricing'
  s.version     = SolidusVolumePricing.version
  s.summary     = 'Allow prices to be configured in quantity ranges for each variant'
  s.description = s.summary
  s.required_ruby_version = '>= 2.2.3'

  s.author       = 'Sean Schofield'
  s.email        = 'sean@railsdog.com'
  s.homepage     = 'https://github.com/solidusio-contrib/solidus_volume_pricing'
  s.license      = 'BSD-3'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'solidus_core', '>= 2.0'
  s.add_runtime_dependency 'solidus_backend', '>= 2.0'
  s.add_runtime_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'capybara', '~> 3.1'
  s.add_development_dependency 'ffaker', '>= 1.32.1'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec-rails', '~> 3.2'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'pry-rails', '>= 0.3'
  s.add_development_dependency 'poltergeist', '~> 1.6'
  s.add_development_dependency 'database_cleaner', '~> 1.4'
  s.add_development_dependency 'coffee-rails', '~> 4.0'
  s.add_development_dependency 'sassc-rails'
  s.add_development_dependency 'rubocop', '>= 0.24.1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'solidus_support'
end
