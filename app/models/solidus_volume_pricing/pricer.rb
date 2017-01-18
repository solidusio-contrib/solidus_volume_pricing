module SolidusVolumePricing
  class Pricer < Spree::Variant::PriceSelector
    attr_reader :quantity, :user

    def self.pricing_options_class
      SolidusVolumePricing::PricingOptions
    end

    def price_for(pricing_options)
      @quantity = pricing_options.quantity
      @user = pricing_options.user

      if volume_prices.empty?
        variant.display_price
      else
        Spree::Money.new(computed_price)
      end
    end

    private

    def use_master_variant_volume_pricing?
      Spree::Config.use_master_variant_volume_pricing && @variant.volume_prices.empty?
    end

    def variant
      if use_master_variant_volume_pricing?
        super.product.master
      else
        super
      end
    end

    def volume_prices
      Spree::VolumePrice.for_variant(variant, user: user)
    end

    def computed_price
      volume_price = volume_prices.detect do |vp|
        vp.include?(quantity)
      end

      case volume_price.try!(:discount_type)
      when 'price'
        volume_price.amount
      when 'dollar'
        variant.price - volume_price.amount
      when 'percent'
        variant.price * (1 - volume_price.amount)
      else
        variant.price
      end
    end
  end
end
