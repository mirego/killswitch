FactoryGirl.define do
  factory :organization do
    # Attributes
    name { Faker::Company.name }
  end
end
