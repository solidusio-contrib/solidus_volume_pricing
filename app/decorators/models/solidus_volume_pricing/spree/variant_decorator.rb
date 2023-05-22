# frozen_string_literal: true

module SolidusVolumePricing
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.class_eval do
          has_and_belongs_to_many :volume_price_models
          has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
          has_many :model_volume_prices, -> {
            order(position: :asc)
          }, class_name: '::Spree::VolumePrice', through: :volume_price_models, source: :volume_prices
          accepts_nested_attributes_for :volume_prices, allow_destroy: true,
            reject_if: proc { |volume_price|
                         volume_price[:amount].blank? && volume_price[:range].blank?
                       }
        end
      end

      ::Spree::Variant.prepend self
    end
  end
end
