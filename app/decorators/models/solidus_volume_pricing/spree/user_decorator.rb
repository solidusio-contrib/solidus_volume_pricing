# frozen_string_literal: true

module SolidusVolumePricing
  module Spree
    module UserDecorator
      def resolve_role
        if has_spree_role? ::Spree::Config.volume_pricing_role.to_sym
          ::Spree::Role.find_by name: ::Spree::Config.volume_pricing_role
        else
          ::Spree::Role.find_by name: 'user'
        end
      end

      ::Spree.user_class.prepend self
    end
  end
end
