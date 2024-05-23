# frozen_string_literal: true

require 'spree/core'
require 'solidus_support'

module SolidusVolumePricing
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_volume_pricing'

    initializer 'solidus_volume_pricing.preferences', before: 'spree.environment' do
      ::Spree::AppConfiguration.class_eval do
        preference :use_master_variant_volume_pricing, :boolean, default: false
      end
    end

    def self.activate
      ::Spree::BackendConfiguration::CONFIGURATION_TABS << :volume_price_models
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
