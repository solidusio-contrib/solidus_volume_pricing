Spree::BaseHelper.class_eval do
  def display_volume_price(variant, quantity = 1, user = nil)
    price_display(variant, quantity: quantity, user: user).price_string
  end

  def display_volume_price_earning_percent(variant, quantity = 1, user = nil)
    variant.volume_price_earning_percent(quantity, user).round.to_s
  end

  def display_volume_price_earning_amount(variant, quantity = 1, user = nil)
    price_display(variant, quantity: quantity, user: user).earning_string
  end

  private

  def price_display(variant, quantity:, user:)
    SolidusVolumePricing::PriceDisplay.new(variant, quantity: quantity, user: user)
  end
end
