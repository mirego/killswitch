FactoryGirl.define do
  factory :application do
    # Attributes
    name { FFaker::Company.name }

    # Associations
    association :organization
  end
end
