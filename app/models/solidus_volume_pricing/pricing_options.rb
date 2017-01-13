module SolidusVolumePricing
  class PricingOptions < Spree::Variant::PricingOptions
    attr_accessor :quantity, :user

    def initialize(options = {})
      super options.except(:quantity, :user)
      @quantity = options.delete(:quantity)
      @user = options.delete(:user)
    end

    def self.from_line_item(line_item)
      pricing_options = super(line_item)
      pricing_options.quantity = line_item.quantity
      pricing_options.user = line_item.order.user
      pricing_options
    end
  end
end
