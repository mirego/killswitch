require 'spec_helper'

describe User do
  describe :Factories do
    subject { create(:user) }
    it { should be_valid }
  end
end
