# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_volume_pricing/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_volume_pricing'
  s.version     = SolidusVolumePricing.version
  s.summary     = 'Allow prices to be configured in quantity ranges for each variant'
  s.description = s.summary

  s.required_ruby_version = '~> 2.4'

  s.author       = 'Sean Schofield'
  s.email        = 'sean@railsdog.com'
  s.homepage     = 'https://github.com/solidusio-contrib/solidus_volume_pricing'
  s.license      = 'BSD-3'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.add_runtime_dependency 'deface', '~> 1.0'
  s.add_runtime_dependency 'solidus_backend', '>= 2.0'
  s.add_runtime_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  s.add_runtime_dependency 'solidus_support', '~> 0.4.0'

  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'solidus_dev_support'
end
