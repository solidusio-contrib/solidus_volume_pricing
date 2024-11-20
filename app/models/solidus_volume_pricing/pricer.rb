# frozen_string_literal: true

module SolidusVolumePricing
  class Pricer < ::Spree::Variant::PriceSelector
    attr_reader :quantity, :user

    def self.pricing_options_class
      SolidusVolumePricing::PricingOptions
    end

    def price_for(pricing_options)
      extract_options(pricing_options)
      ::Spree::Money.new(computed_price(pricing_options.quantity))
    end

    def earning_amount(pricing_options)
      extract_options(pricing_options)
      ::Spree::Money.new(computed_earning(pricing_options.quantity))
    end

    def earning_percent(pricing_options)
      extract_options(pricing_options)
      computed_earning_percent(pricing_options.quantity).round
    end

    def volume_pricing?(pricing_options)
      extract_options(pricing_options)
      get_volume_price_for(pricing_options.quantity).present?
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

    def get_volume_price_for(quantity)
      volume_prices.detect do |volume_price|
        volume_price.include?(quantity)
      end
    end

    def computed_price(quantity)
      volume_price = get_volume_price_for(quantity)
      band_price = case volume_price&.discount_type
                   when /price/
                     volume_price.amount
                   when /dollar/
                     variant.price - volume_price.amount
                   when /percent/
                     variant.price * (1 - volume_price.amount)
                   else
                     variant.price
                   end

      if volume_price&.discount_type&.starts_with?('banded_')
        range_start = volume_price.begin
        amount = quantity - range_start + 1
        band_total = amount * band_price
        if range_start > 1
          band_total += computed_price(range_start - 1) * (range_start - 1)
        end
        band_total / quantity
      else
        band_price
      end
    end

    def computed_earning(quantity)
      total_with_discount = computed_price(quantity) * quantity
      total_without_discount = variant.price * quantity
      (total_without_discount - total_with_discount) / quantity
    end

    def computed_earning_percent(quantity)
      total_with_discount = computed_price(quantity) * quantity
      total_without_discount = variant.price * quantity
      100 - (total_with_discount * 100 / total_without_discount)
    end
  end
end
