# frozen_string_literal: true

module SolidusVolumePricing
  module Spree
    module LineItemDecorator
      def set_pricing_attributes
        if quantity_changed?
          options = SolidusVolumePricing::PricingOptions.from_line_item(self)
          pricer = SolidusVolumePricing::Pricer.new(variant)
          if pricer.volume_pricing?(options)
            self.money_price = pricer.price_for(options)
          end
        end

        super
      end

      ::Spree::LineItem.prepend self
    end
  end
end
