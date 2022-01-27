require 'spec_helper'

describe Organization do
  describe :Factories do
    subject { create(:organization) }
    it { should be_valid }
  end
end
