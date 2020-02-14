# frozen_string_literal: true

RSpec.describe Spree::VolumePrice, type: :model do
  let(:volume_price) do
    described_class.new(variant: Spree::Variant.new, amount: 10, discount_type: 'price')
  end

  it { is_expected.to belong_to(:variant).touch(true).optional }
  it { is_expected.to belong_to(:volume_price_model).touch(true).optional }
  it { is_expected.to belong_to(:spree_role).class_name('Spree::Role').with_foreign_key('role_id').optional }
  it { is_expected.to validate_presence_of(:discount_type) }
  it { is_expected.to validate_presence_of(:amount) }

  it do
    expect(subject).to \
      validate_inclusion_of(:discount_type).
      in_array(%w(price dollar percent)).
      with_message('shoulda-matchers test string is not a valid Volume Price Type')
  end

  describe '.for_variant' do
    subject { described_class.for_variant(variant, user: user) }

    let(:user) { nil }
    let(:variant) { create(:variant) }
    let!(:volume_prices) { create_list(:volume_price, 2, variant: variant, name:'Prices independent of role') }

    context 'if no user is given' do
      it 'returns all volume prices for given variant that are not related to a specific role' do
        expect(subject).to eq(volume_prices)
      end
    end

    context 'if user is given' do
      let(:role) do
        create(:role, name: 'merchant')
      end

      let(:alt_role) do
        create(:role, name: 'partner')
      end

      let(:user) do
        create(:user)
      end

      let!(:volume_prices_for_user_role) do
        create_list(:volume_price, 2, variant: variant, role_id: role.id, name: 'Prices for preferenced role')
      end

      let!(:volume_prices_for_alt_user_role) do
        create_list(:volume_price, 2, variant: variant, role_id: alt_role.id, name: 'Prices for arbitrary role')
      end

      before do
        stub_spree_preferences(volume_pricing_role: role.name)
      end

      context 'whose role matches' do
        before do
          user.spree_roles = [role]
        end

        it 'returns role specific volume prices' do
          expect(subject).to include(*volume_prices_for_user_role)
        end

        it 'returns non-role specific volume prices' do
          expect(subject).to include(*volume_prices)
        end
      end

      context 'whose role matches but is not configured at the application level' do
        before do
          user.spree_roles = [alt_role]
        end

        it 'returns role specific volume prices' do
          expect(subject).to include(*volume_prices_for_alt_user_role)
        end

        it 'returns non-role specific volume prices' do
          expect(subject).to include(*volume_prices)
        end
      end

      context 'whose role does not match' do
        before do
          user.spree_roles = []
        end

        it 'does not include role specific volume prices' do
          expect(subject).not_to include(*volume_prices_for_user_role)
        end

        it 'returns non-role specific volume prices' do
          expect(subject).to include(*volume_prices)
        end
      end
    end

    context 'if volume prices are not related to the variant but to a volume price model' do
      let(:volume_price_model) do
        create(:volume_price_model)
      end

      let!(:volume_prices_from_model) do
        create_list(:volume_price, 2, volume_price_model: volume_price_model, variant: nil)
      end

      context 'and these volume prices are also related to the given variant' do
        let(:variant) do
          create(:variant, volume_price_models: [volume_price_model])
        end

        it 'includes these volume prices' do
          expect(subject).to include(*volume_prices_from_model)
        end
      end

      context 'and these volume prices are not related to the given variant' do
        it 'does not include these volume prices' do
          expect(subject).not_to include(*volume_prices_from_model)
        end
      end
    end
  end

  describe 'valid range format' do
    it 'requires the presence of a variant' do
      volume_price.variant = nil
      expect(volume_price).not_to be_valid
    end

    it 'consider a range of (1..2) to be valid' do
      volume_price.range = '(1..2)'
      expect(volume_price).to be_valid
    end

    it 'consider a range of (1...2) to be valid' do
      volume_price.range = '(1...2)'
      expect(volume_price).to be_valid
    end

    it 'consider a range of 1..2 to be valid' do
      volume_price.range = '1..2'
      expect(volume_price).to be_valid
    end

    it 'consider a range of 1...2 to be valid' do
      volume_price.range = '1...2'
      expect(volume_price).to be_valid
    end

    it 'consider a range of (10+) to be valid' do
      volume_price.range = '(10+)'
      expect(volume_price).to be_valid
    end

    it 'consider a range of 10+ to be valid' do
      volume_price.range = '10+'
      expect(volume_price).to be_valid
    end

    it 'does not consider a range of 1-2 to valid' do
      volume_price.range = '1-2'
      expect(volume_price).not_to be_valid
    end

    it 'does not consider a range of 1 to valid' do
      volume_price.range = '1'
      expect(volume_price).not_to be_valid
    end

    it 'does not consider a range of foo to valid' do
      volume_price.range = 'foo'
      expect(volume_price).not_to be_valid
    end
  end

  describe 'display_range' do
    subject(:display_range) { volume_price.display_range }

    let(:volume_price) { described_class.new(range: range) }

    context 'with parens' do
      let(:range) { '(48+)' }

      it { is_expected.to eq('48+') }
    end

    context 'with range dots' do
      let(:range) { '1..3' }

      it { is_expected.to eq('1-3') }
    end

    context 'with range dots and parens' do
      let(:range) { '(1..3)' }

      it { is_expected.to eq('1-3') }
    end
  end

  describe 'include?' do
    ['10..20', '(10..20)'].each do |range|
      it "does not match a quantity that fails to fall within the specified range of #{range}" do
        volume_price.range = range
        expect(volume_price).not_to include(21)
      end

      it "matches a quantity that is within the specified range of #{range}" do
        volume_price.range = range
        expect(volume_price).to include(12)
      end

      it 'matches the upper bound of ranges that include the upper bound' do
        volume_price.range = range
        expect(volume_price).to include(20)
      end
    end

    ['10...20', '(10...20)'].each do |range|
      it 'does not match the upper bound for ranges that exclude the upper bound' do
        volume_price.range = range
        expect(volume_price).not_to include(20)
      end
    end

    ['50+', '(50+)'].each do |range|
      it "matches a quantity that exceeds the value of an open ended range of #{range}" do
        volume_price.range = range
        expect(volume_price).to include(51)
      end

      it "matches a quantity that equals the value of an open ended range of #{range}" do
        volume_price.range = range
        expect(volume_price).to include(50)
      end

      it "does not match a quantity that is less then the value of an open ended range of #{range}" do
        volume_price.range = range
        expect(volume_price).not_to include(40)
      end
    end
  end
end
