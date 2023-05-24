# frozen_string_literal: true

require_relative 'lib/solidus_volume_pricing/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_volume_pricing'
  spec.version = SolidusVolumePricing::VERSION
  spec.authors = ['Sean Schofield']
  spec.email = 'sean@railsdog.com'

  spec.summary = 'Allow prices to be configured in quantity ranges for each variant'
  spec.description = 'Allow prices to be configured in quantity ranges for each variant'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_volume_pricing'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_volume_pricing'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_volume_pricing/releases'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 4')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'solidus_backend', ['>= 2.4.0', '< 5']
  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'deface'
  spec.add_dependency 'sassc-rails'
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 5']
  spec.add_dependency 'solidus_support', '~> 0.8'

  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'solidus_dev_support', '~> 2.6'
end
