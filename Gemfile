source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', git: 'https://github.com/solidusio/solidus.git', branch: branch

if ENV['DB'] == 'mysql'
  gem 'mysql2', '~> 0.4.10'
else
  gem 'pg', '~> 0.21'
end

if branch < 'v2.5'
  gem 'factory_bot', '4.11.1'
else
  gem 'factory_bot', '4.11.1'
end

gemspec
