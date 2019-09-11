require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'solidus_support'
require 'solidus_support/extension/feature_helper'

require 'capybara/rspec'

require 'spree/testing_support/controller_requests'
require 'spree/testing_support/capybara_ext'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

FactoryBot.use_parent_strategy = false
FactoryBot.find_definitions

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.include Spree::TestingSupport::ControllerRequests, type: :controller
end
