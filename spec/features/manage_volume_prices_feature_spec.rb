# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Managing volume prices' do
  stub_authorization!

  let(:variant) { create(:variant) }

  it 'an admin can create and remove volume prices', :js do
    visit spree.edit_admin_product_path(variant.product)
    click_on 'Volume Pricing'
    expect(page).to have_content('Volume Prices')

    fill_in 'variant_volume_prices_attributes_0_name', with: '5 pieces discount'
    select 'Total price (All items)', from: 'variant_volume_prices_attributes_0_discount_type'
    fill_in 'variant_volume_prices_attributes_0_range', with: '1..5'
    fill_in 'variant_volume_prices_attributes_0_amount', with: '1'
    click_on 'Update'

    expect(page).to have_field('variant_volume_prices_attributes_0_name', with: '5 pieces discount')
    accept_confirm { page.find('a[data-action="remove"]').click }

    expect(page).not_to have_field('variant_volume_prices_attributes_0_name', with: '5 pieces discount')
  end

  it 'an admin editing a variant has a new volume price already built for her' do
    visit spree.edit_admin_product_variant_path(product_id: variant.product, id: variant)
    within '#volume_prices' do
      expect(page).to have_field('variant_volume_prices_attributes_0_name')
    end
  end
end
