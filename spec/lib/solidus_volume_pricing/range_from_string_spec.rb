require 'spec_helper'

RSpec.describe SolidusVolumePricing::RangeFromString do
  describe 'new' do
    subject(:range) { described_class.new(argument).to_range }

    context 'with a string with two dots' do
      let(:argument) { '1..2' }
      it { is_expected.to eq(1..2) }
    end

    context 'with a string with two dots and parens' do
      let(:argument) { '(1..2)' }
      it { is_expected.to eq(1..2) }
    end

    context 'with a string with three dots' do
      let(:argument) { '1...2' }
      it { is_expected.to eq(1...2) }
    end

    context 'with a string with three dots and parens' do
      let(:argument) { '(1...2)' }
      it { is_expected.to eq(1...2) }
    end

    context 'with an open-ended string like #{x}+' do
      let(:argument) { '10+' }
      it { is_expected.to eq(10..Float::INFINITY) }
    end

    context 'with an open-ended string like #{x}+ and parens' do
      let(:argument) { '(10+)' }
      it { is_expected.to eq(10..Float::INFINITY) }
    end

    context 'with invalid input' do
      let(:argument) { 'system("rm -rf /*")' }
      it do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'with invalid input' do
      let(:argument) { '1..3; puts "Do not run Ruby Code"' }
      it do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
