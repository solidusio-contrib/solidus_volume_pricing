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

    def earning_string
      earning.to_s
    end

    private

    def price
      pricer.price_for(options)
    end

    def earning
      pricer.earning_amount(options)
    end

    def options
      SolidusVolumePricing::PricingOptions.new(quantity: quantity, user: user)
    end

    def pricer
      SolidusVolumePricing::Pricer.new(variant)
    end
  end
end
