source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch

if ENV['DB'] == 'mysql'
  gem 'mysql2', '~> 0.4.10'
else
  gem 'pg', '~> 0.21'
end

if branch < 'v2.5'
  gem 'factory_bot', '4.10.0'
else
  gem 'factory_bot', '> 4.10.0'
end

gemspec
