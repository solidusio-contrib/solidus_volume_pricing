module Spree
  module Admin
    class VolumePricesController < Spree::Admin::BaseController
      def destroy
        @volume_price = Spree::VolumePrice.find(params[:id])
        @volume_price.destroy
        head :ok
      end
    end
  end
end
