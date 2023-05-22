# frozen_string_literal: true

module Spree
  class VolumePriceModel < ApplicationRecord
    has_many :variants, dependent: :nullify
    has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :volume_prices, allow_destroy: true,
      reject_if: proc { |volume_price|
                   volume_price[:amount].blank? && volume_price[:range].blank?
                 }
  end
end
