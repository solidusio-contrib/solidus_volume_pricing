RSpec.describe Spree::Variant, type: :model do
  it { is_expected.to have_many(:volume_prices) }

  let(:variant) { create(:variant, price: 10) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }

  describe '#volume_price_earning_percent' do
    context 'discount_type = price' do
      before :each do
        variant.volume_prices.create! amount: 9, discount_type: 'price', range: '(10+)'
      end

      it 'gives percent of earning without role' do
        expect(variant.volume_price_earning_percent(10)).to be(10)
      end

      it 'gives percent of earning if role matches' do
        user.spree_roles << role
        Spree::Config.volume_pricing_role = role.name
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10, user)).to be(10)
      end

      it 'gives zero percent earning if doesnt match' do
        expect(variant.volume_price_earning_percent(1)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match with null' do
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match' do
        other_role = create(:role)
        user.spree_roles << other_role
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10, user)).to be(0)
      end
    end

    context 'discount_type = dollar' do
      before :each do
        variant.volume_prices.create! amount: 1, discount_type: 'dollar', range: '(10+)'
      end

      it 'gives percent of earning without role' do
        expect(variant.volume_price_earning_percent(10)).to be(10)
      end

      it 'gives percent of earning if role matches' do
        user.spree_roles << role
        Spree::Config.volume_pricing_role = role.name
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10, user)).to be(10)
      end

      it 'gives zero percent earning if doesnt match' do
        expect(variant.volume_price_earning_percent(1)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match with null' do
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match' do
        other_role = create(:role)
        user.spree_roles << other_role
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10, user)).to be(0)
      end
    end

    context 'discount_type = percent' do
      before :each do
        variant.volume_prices.create! amount: 0.1, discount_type: 'percent', range: '(10+)'
      end

      it 'gives percent of earning without roles' do
        expect(variant.volume_price_earning_percent(10)).to be(10)
        variant_five = create :variant, price: 10
        variant_five.volume_prices.create! amount: 0.5, discount_type: 'percent', range: '(1+)'
        expect(variant_five.volume_price_earning_percent(1)).to be(50)
      end

      it 'gives amount earning if role matches' do
        user.spree_roles << role
        Spree::Config.volume_pricing_role = role.name
        expect(variant.volume_price_earning_percent(10)).to be(10)
        variant_five = create :variant, price: 10
        variant_five.volume_prices.create! amount: 0.5, discount_type: 'percent', range: '(1+)'
        variant_five.volume_prices.first.update(role_id: role.id)
        expect(variant_five.volume_price_earning_percent(1, user)).to be(50)
      end

      it 'gives zero percent earning if doesnt match' do
        expect(variant.volume_price_earning_percent(1)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match with null' do
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10)).to be(0)
      end

      it 'gives zero percent earning if role doesnt match' do
        other_role = create(:role)
        user.spree_roles << other_role
        variant.volume_prices.first.update(role_id: role.id)
        expect(variant.volume_price_earning_percent(10, user)).to be(0)
      end
    end
  end
end
