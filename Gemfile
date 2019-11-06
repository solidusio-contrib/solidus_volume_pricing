source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

gem 'solidus_kitchen', github: 'solidusio-contrib/solidus_kitchen'

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgres'
  gem 'pg'
else
  gem 'sqlite3'
end

gemspec
