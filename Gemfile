source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'v2.1')
gem "solidus", github: "solidusio/solidus", branch: branch

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
end

gemspec
