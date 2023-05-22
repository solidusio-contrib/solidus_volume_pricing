# frozen_string_literal: true

module Spree
  module Admin
    class VolumePriceModelsController < ResourceController
      before_action :load_volume_prices, only: [:new, :edit] # rubocop:disable Rails/LexicallyScopedActionFilter

      private

      def location_after_save
        if @volume_price_model.created_at == @volume_price_model.updated_at
          edit_admin_volume_price_model_url(@volume_price_model)
        else
          admin_volume_price_models_url
        end
      end

      def load_volume_prices
        @volume_price_model.volume_prices.build if @volume_price_model.volume_prices.empty?
      end
    end
  end
end
