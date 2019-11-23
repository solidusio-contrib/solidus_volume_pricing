# frozen_string_literal: true

require 'shoulda-matchers'

# From: https://github.com/thoughtbot/shoulda-matchers/issues/384
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
