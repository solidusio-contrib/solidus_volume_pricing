source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'v1.3')
gem "solidus", github: "solidusio/solidus", branch: branch

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
end

group :test do
  if branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

gemspec
