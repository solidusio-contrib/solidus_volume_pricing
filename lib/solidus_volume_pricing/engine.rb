# frozen_string_literal: true

require 'spree/core'

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
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      ::Spree::BackendConfiguration::CONFIGURATION_TABS << :volume_price_models
    end

    config.to_prepare(&method(:activate).to_proc)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
