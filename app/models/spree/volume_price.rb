# frozen_string_literal: true

module Spree
  class VolumePrice < ApplicationRecord
    belongs_to :variant, touch: true, optional: true
    belongs_to :volume_price_model, touch: true, optional: true
    belongs_to :spree_role, class_name: "Spree::Role", foreign_key: "role_id", optional: true
    acts_as_list scope: [:variant_id, :volume_price_model_id]

    validates :amount, presence: true
    validates :discount_type,
      presence: true,
      inclusion: {
        in: %w[price dollar percent]
      }

    validate :range_format

    def self.for_variant(variant, user: nil)
      roles = [nil]
      user&.spree_roles&.each { |r| roles << r.id }

      where(
        arel_table[:variant_id].eq(variant.id)
        .or(
          arel_table[:volume_price_model_id].in(variant.volume_price_model_ids)
        )
      )
        .where(role_id: roles)
        .order(position: :asc, amount: :asc)
    end

    delegate :include?, to: :range_from_string

    def display_range
      range.gsub(/\.+/, "-").gsub(/\(|\)/, "")
    end

    private

    def range_format
      if !(SolidusVolumePricing::RangeFromString::RANGE_FORMAT =~ range ||
           SolidusVolumePricing::RangeFromString::OPEN_ENDED =~ range)
        errors.add(:range, :must_be_in_format)
      end
    end

    def range_from_string
      SolidusVolumePricing::RangeFromString.new(range).to_range
    end
  end
end
