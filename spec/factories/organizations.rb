FactoryGirl.define do
  factory :organization do
    # Attributes
    name { FFaker::Company.name }
  end
end
