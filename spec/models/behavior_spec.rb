require 'spec_helper'

describe Behavior do
  describe :Factories do
    subject { create(:behavior) }
    it { should be_valid }
  end

  describe :InstanceMethods do
    let(:behavior) { build(:behavior) }

    describe :language= do
      context 'when passed a non-blank value' do
        before { behavior.language = 'fr' }
        it { expect(behavior.language).to eq 'fr' }
      end

      context 'when passed a blank value' do
        before { behavior.language = nil }
        it { expect(behavior.language).to be_nil }
      end

      context 'when passed nil' do
        before { behavior.language = '' }
        it { expect(behavior.language).to be_nil }
      end
    end

    describe :parsed_version do
      context 'when real version is present and makes sense' do
        before { behavior.version_number = '3.0' }
        it { expect(behavior.parsed_version).to eq '3.0' }
      end
    end

    describe :version_operator_method do
      context 'when version_operator exists' do
        before { behavior.version_operator = 'lt' }
        it { expect(behavior.version_operator_method).to be_present }
      end

      context 'when version_operator doesn’t exist' do
        before { behavior.version_operator = '🐼' }
        it { expect(behavior.version_operator_method).to be_nil }
      end
    end

    describe :time_operator_method do
      context 'when time_operator exists' do
        before { behavior.time_operator = 'lt' }
        it { expect(behavior.time_operator_method).to be_present }
      end

      context 'when time_operator doesn’t exist' do
        before { behavior.time_operator = '🐼' }
        it { expect(behavior.time_operator_method).to be_nil }
      end
    end
  end
end
