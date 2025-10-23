# frozen_string_literal: true

module SolidusVolumePricing
  module SpreeLineItemPatch
    def self.prepended(base)
      base.before_validation :set_volume_pricing_attributes, if: :quantity_changed?
    end

    private

    def set_volume_pricing_attributes
      options = SolidusVolumePricing::PricingOptions.from_line_item(self)
      self.money_price = SolidusVolumePricing::Pricer.new(variant).price_for(options)
    end

    ::Spree::LineItem.prepend self
  end
end
