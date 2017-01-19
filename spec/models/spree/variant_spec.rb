RSpec.describe Spree::Variant, type: :model do
  it { is_expected.to have_many(:volume_prices) }
end
