# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusVolumePricing::PricingOptions do
  let(:user) do
    build_stubbed(:user)
  end

  it 'inherits from default pricing options class' do
    expect(described_class < Spree::Variant::PricingOptions).to be(true)
  end

  describe 'new instances' do
    subject do
      described_class.new(quantity: 10, user: user)
    end

    it 'have a quantity attribute' do
      expect(subject.quantity).to eq(10)
    end

    it 'have a user attribute' do
      expect(subject.user).to eq(user)
    end

    it 'desired_attributes dont have quantity key' do
      expect(subject.desired_attributes).not_to have_key(:quantity)
    end

    it 'desired_attributes dont have user key' do
      expect(subject.desired_attributes).not_to have_key(:user)
    end
  end

  describe '.from_line_item' do
    subject do
      described_class.from_line_item(line_item)
    end

    let(:order) do
      build_stubbed(:order, user: user)
    end

    let(:line_item) do
      build_stubbed(:line_item, quantity: 2, order: order)
    end

    it 'sets quantity to quantity of line item' do
      expect(subject.quantity).to eq(2)
    end

    it 'sets user to user of line item' do
      expect(subject.user).to eq(user)
    end
  end
end
