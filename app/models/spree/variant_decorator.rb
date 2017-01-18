Spree::Variant.class_eval do
  has_and_belongs_to_many :volume_price_models
  has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
  has_many :model_volume_prices, -> { order(position: :asc) }, class_name: 'Spree::VolumePrice', through: :volume_price_models, source: :volume_prices
  accepts_nested_attributes_for :volume_prices, allow_destroy: true,
    reject_if: proc { |volume_price|
      volume_price[:amount].blank? && volume_price[:range].blank?
    }

  # return percent of earning
  def volume_price_earning_percent(quantity, user = nil)
    compute_volume_price_quantities :volume_price_earning_percent, 0, quantity, user
  end

  protected

  def use_master_variant_volume_pricing?
    Spree::Config.use_master_variant_volume_pricing && !(Spree::VolumePrice.for_variant(product.master).count == 0)
  end

  def compute_volume_price_quantities(type, default_price, quantity, user)
    volume_prices = Spree::VolumePrice.for_variant(self, user: user)
    if volume_prices.count == 0
      if use_master_variant_volume_pricing?
        product.master.send(type, quantity, user)
      else
        return default_price
      end
    else
      volume_prices.each do |volume_price|
        if volume_price.include?(quantity)
          return send "compute_#{type}".to_sym, volume_price
        end
      end

      # No price ranges matched.
      default_price
    end
  end

  def compute_volume_price_earning_percent(volume_price)
    case volume_price.discount_type
    when 'price'
      diff = price - volume_price.amount
      return (diff * 100 / price).round
    when 'dollar'
      return (volume_price.amount * 100 / price).round
    when 'percent'
      return (volume_price.amount * 100).round
    end
  end
end
