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

    if SolidusSupport.backend_available?
      initializer 'solidus_volume_pricing.admin_menu_item', after: 'solidus_volume_pricing.preferences' do
        Spree::Backend::Config.configure do |config|
          settings_menu_item = config.menu_items.detect { |mi| mi.label == :settings }

          # The API of the MenuItem class changes in Solidus 4.2.0
          if settings_menu_item.respond_to?(:children)
            settings_menu_item.children.concat([
              Spree::BackendConfiguration::MenuItem.new(
                label: :volume_price_models,
                url: :admin_volume_price_models_path,
                match_path: %r{admin/volume_price_models}
              )
            ])
          else
            ::Spree::BackendConfiguration::CONFIGURATION_TABS << :volume_price_models
          end
        end
      end
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
