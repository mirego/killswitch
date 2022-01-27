require 'spec_helper'

describe Application do
  describe :Factories do
    subject { create(:application) }
    it { should be_valid }
  end
end
