module Spree
  module LineItemPriceUpdater
    def set_pricing_attributes
      super

      if quantity_changed?
        self.price = variant.volume_price(quantity, order.user)
      end
    end
  end
end

Spree::LineItem.prepend(Spree::LineItemPriceUpdater)
