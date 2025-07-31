# frozen_string_literal: true

module SolidusVolumePricing
  class Pricer < ::Spree::Variant::PriceSelector
    attr_reader :quantity, :user

    def self.pricing_options_class
      SolidusVolumePricing::PricingOptions
    end

    def price_for(pricing_options)
      extract_options(pricing_options)
      ::Spree::Money.new(computed_price)
    end

    def earning_amount(pricing_options)
      extract_options(pricing_options)
      ::Spree::Money.new(computed_earning)
    end

    def earning_percent(pricing_options)
      extract_options(pricing_options)
      computed_earning_percent.round
    end

    private

    def extract_options(pricing_options)
      @quantity = pricing_options.quantity
      @user = pricing_options.user
    end

    def use_master_variant_volume_pricing?
      ::Spree::Config.use_master_variant_volume_pricing && @variant.volume_prices.empty?
    end

    def variant
      if use_master_variant_volume_pricing?
        super.product.master
      else
        super
      end
    end

    def volume_prices
      ::Spree::VolumePrice.for_variant(variant, user: user)
    end

    def volume_price
      volume_prices.detect do |volume_price|
        volume_price.include?(quantity)
      end
    end

    def computed_price
      case volume_price&.discount_type
      when "price"
        volume_price.amount
      when "dollar"
        variant.price - volume_price.amount
      when "percent"
        variant.price * (1 - volume_price.amount)
      else
        variant.price
      end
    end

    def computed_earning
      case volume_price&.discount_type
      when "price"
        variant.price - volume_price.amount
      when "dollar"
        volume_price.amount
      when "percent"
        variant.price - (variant.price * (1 - volume_price.amount))
      else
        0
      end
    end

    def computed_earning_percent
      case volume_price&.discount_type
      when "price"
        diff = variant.price - volume_price.amount
        diff * 100 / variant.price
      when "dollar"
        volume_price.amount * 100 / variant.price
      when "percent"
        volume_price.amount * 100
      else
        0
      end
    end
  end
end
