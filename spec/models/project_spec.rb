require 'spec_helper'

describe Project do
  describe :Factories do
    subject { create(:project) }
    it { should be_valid }
  end
end
