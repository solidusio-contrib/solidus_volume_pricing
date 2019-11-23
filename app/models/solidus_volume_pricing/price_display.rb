# frozen_string_literal: true

module SolidusVolumePricing
  class PriceDisplay
    attr_reader :variant, :quantity, :user

    def initialize(variant, quantity: 1, user: nil)
      @variant = variant
      @quantity = quantity
      @user = user
    end

    def price_string
      price.to_s
    end

    def earning_amount_string
      earning_amount.to_s
    end

    def earning_percent_string
      earning_percent.to_s
    end

    private

    def price
      pricer.price_for(options)
    end

    def earning_amount
      pricer.earning_amount(options)
    end

    def earning_percent
      pricer.earning_percent(options)
    end

    def options
      SolidusVolumePricing::PricingOptions.new(quantity: quantity, user: user)
    end

    def pricer
      SolidusVolumePricing::Pricer.new(variant)
    end
  end
end
