RSpec.describe Spree::Variant, type: :model do
  it { is_expected.to have_many(:volume_prices) }
  it { is_expected.to have_many(:model_volume_prices) }
end
