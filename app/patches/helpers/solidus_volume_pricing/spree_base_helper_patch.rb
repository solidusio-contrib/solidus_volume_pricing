# frozen_string_literal: true

module SolidusVolumePricing
  module SpreeBaseHelperPatch
    def self.prepended(base)
      base.module_eval do
        def display_volume_price(variant, quantity = 1, user = nil)
          price_display(variant, quantity: quantity, user: user).price_string
        end

        def display_volume_price_earning_percent(variant, quantity = 1, user = nil)
          price_display(variant, quantity: quantity, user: user).earning_percent_string
        end

        def display_volume_price_earning_amount(variant, quantity = 1, user = nil)
          price_display(variant, quantity: quantity, user: user).earning_amount_string
        end

        private

        def price_display(variant, quantity:, user:)
          SolidusVolumePricing::PriceDisplay.new(variant, quantity: quantity, user: user)
        end
      end
    end

    ::Spree::BaseHelper.prepend self
  end
end
