Spree::BaseHelper.class_eval do
  def display_volume_price(variant, quantity = 1, user = nil)
    options = SolidusVolumePricing::PricingOptions.new(quantity: quantity, user: user)
    SolidusVolumePricing::Pricer.new(variant).price_for(options).to_html
  end

  def display_volume_price_earning_percent(variant, quantity = 1, user = nil)
    variant.volume_price_earning_percent(quantity, user).round.to_s
  end

  def display_volume_price_earning_amount(variant, quantity = 1, user = nil)
    Spree::Money.new(
      variant.volume_price_earning_amount(quantity, user),
      currency: Spree::Config[:currency]
    ).to_html
  end
end
