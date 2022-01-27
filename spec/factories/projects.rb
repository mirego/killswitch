FactoryGirl.define do
  factory :project do
    # Attributes
    name { Faker::Company.name }

    # Associations
    association :application
  end
end
