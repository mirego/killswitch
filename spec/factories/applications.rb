FactoryGirl.define do
  factory :application do
    # Attributes
    name { Faker::Company.name }

    # Associations
    association :organization
  end
end
