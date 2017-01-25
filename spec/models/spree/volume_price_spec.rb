RSpec.describe Spree::VolumePrice, type: :model do
  it { is_expected.to belong_to(:variant).touch(true) }
  it { is_expected.to belong_to(:volume_price_model).touch(true) }
  it { is_expected.to belong_to(:spree_role).class_name('Spree::Role').with_foreign_key('role_id') }
  it { is_expected.to validate_presence_of(:discount_type) }
  it { is_expected.to validate_inclusion_of(:discount_type).in_array(%w(price dollar percent)) }
  it { is_expected.to validate_presence_of(:amount) }

  let(:volume_price) do
    Spree::VolumePrice.new(variant: Spree::Variant.new, amount: 10, discount_type: 'price')
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
    let(:volume_price) { Spree::VolumePrice.new(range: range) }

    subject(:display_range) { volume_price.display_range }

    context 'with parens' do
      let(:range) { '(48+)' }
      it { is_expected.to eq('48+')}
    end

    context 'with range dots' do
      let(:range) { '1..3' }
      it { is_expected.to eq('1-3')}
    end

    context 'with range dots and parens' do
      let(:range) { '(1..3)' }
      it { is_expected.to eq('1-3')}
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
